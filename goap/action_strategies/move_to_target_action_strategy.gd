class_name MoveToTargetActionStrategy
extends ActionStrategy


var _target: String
var _distance_offset: float = 10.0:
	set(value):
		# Ensure offset is 1.0 or above
		_distance_offset = max(value, 1.0)


func _init(target: String, distance_offset: float) -> void:
	_target = target
	_distance_offset = distance_offset


func _start(actor: Node) -> bool:
	if not _target:
		push_error("MoveToTargetActionStrategy._start: 'target object' must be set")
		return false
	
	self.context.target_object = SceneManager.get_closest_element(_target, actor)
	
	if self.context.target_object == null:
		return false

	return true


func _execute(actor: Node, delta: float) -> bool:
	# Ensure target_position is set
	var target_position: Vector2 = self.context.target_object.position

	if actor.position.distance_to(target_position) < _distance_offset:
		return true
	
	actor.move_to(actor.position.direction_to(target_position), delta)
	
	return false
