extends GoapAction

class_name ChopTreeAction


func _init() -> void:
	preconditions.append(GoapState.new(Goap.States.HAS_WOOD, false))
	effects.append(GoapState.new(Goap.States.HAS_WOOD, true))
	strategy = MoveToTargetActionStrategy.new("tree", 10.0)


func get_clazz(): return "ChopTreeAction"


func is_valid() -> bool:
	return SceneManager.get_elements("tree").size() > 0


func get_cost(blackboard) -> int:
	if blackboard.position:
		var closest_tree = SceneManager.get_closest_element("tree", blackboard)
		return int(closest_tree.position.distance_to(blackboard.position) / 5)
	return 5


func perform(actor, delta) -> bool:
	if strategy.execute(actor, delta):
		if actor.chop_tree(strategy.target_object):
			return true

	return false
