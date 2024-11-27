extends GoapAction

class_name ChopTreeAction


func _init() -> void:
	preconditions.append(GoapState.new(Goap.States.HAS_WOOD, false))
	effects.append(GoapState.new(Goap.States.HAS_WOOD, true))


func get_clazz(): return "ChopTreeAction"


func is_valid() -> bool:
	return SceneManager.get_elements("tree").size() > 0


func get_cost(blackboard) -> int:
	if blackboard.position:
		var closest_tree = SceneManager.get_closest_element("tree", blackboard)
		return int(closest_tree.position.distance_to(blackboard.position) / 5)
	return 5


func perform(actor, delta) -> bool:
	var _closest_tree = SceneManager.get_closest_element("tree", actor)

	if _closest_tree:
		if _closest_tree.position.distance_to(actor.position) < 10:
				if actor.chop_tree(_closest_tree):
					Goap.world_state.has_wood = true
					return true
				return false
		else:
			actor.move_to(actor.position.direction_to(_closest_tree.position), delta)

	return false
