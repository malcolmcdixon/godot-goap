extends ActionStrategy
class_name MoveToTargetActionStrategy


var _target_position: Vector2
var target_position: Vector2:
	get:
		return _target_position
		
var _target: String
var _target_object: Node
var target_object: Node:
	get:
		return _target_object

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
	
	_target_object = SceneManager.get_closest_element(_target, actor)
	
	if not _target_object:
		return false
	
	_target_position = _target_object.position
	
	return true


func _execute(actor: Node, delta: float) -> bool:
	# Ensure target_position is set
	if _target_position == null:
		push_error("MoveToTargetActionStrategy.execute: '_target_position is null.")
		return false

	if actor.position.distance_to(_target_position) < _distance_offset:
		return true
	
	actor.move_to(actor.position.direction_to(_target_position), delta)
	
	return false
