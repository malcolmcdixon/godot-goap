extends ActionStrategy
class_name MoveToTargetStrategy


var _target_position: Vector2
var target_position: Vector2:
	get:
		return _target_position
		
var target_object: String
var distance_offset: float = 10.0:
	set(value):
		# Ensure offset is 1.0 or above
		distance_offset = max(value, 1.0)


func _start(actor: Node) -> bool:
	if not target_object:
		push_error("MoveToTargetStrategy._start: 'target object' must be set")
		return false
	
	var closest_element: Node = \
		SceneManager.get_closest_element(target_object, actor)
	
	if not closest_element:
		return false
	
	_target_position = closest_element.position
	
	return true


func _execute(actor: Node, delta: float) -> bool:
	if not _started:
		if not _start(actor):
			return false

	# Ensure target_position is set
	if _target_position == null:
		push_error("MoveToTargetStrategy.execute: '_target_position is null.")
		return false

	if actor.position.distance_to(_target_position) < distance_offset:
		return true
	
	actor.move_to(actor.position.direction_to(_target_position), delta)
	
	return false
