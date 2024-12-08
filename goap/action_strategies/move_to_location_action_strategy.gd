class_name MoveToLocationActionStrategy
extends ActionStrategy


var _location_group: StringName


func _init(location_group: StringName) -> void:
	_location_group = location_group


func _start(_actor: Node) -> bool:
	if not _location_group:
		push_error("MoveToLocationActionStrategy._start: 'location group' must be set")
		return false

	var location_node: Node2D = SceneManager.get_element(_location_group)
	if location_node == null:
		return false
		
	self.context.avoid_location = location_node.global_position
	return true


func _execute(actor: Node, delta: float) -> bool:
	# Ensure target_position is set
	var location: Vector2 = self.context.avoid_location

	if actor.position.distance_to(location) < 10.0:
		return true
	
	actor.move_to(actor.position.direction_to(location), delta)
	
	return false
