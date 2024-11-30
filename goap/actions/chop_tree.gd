class_name ChopTreeAction
extends GoapAction


func _init() -> void:
	preconditions.append(GoapState.new(Goap.States.HAS_WOOD, false))

	effects.append(GoapState.new(Goap.States.HAS_WOOD, true))

	strategy = MultiActionStrategy.new(
		[
			MoveToTargetActionStrategy.new("tree", 10.0),
			DoActionStrategy.new(
				func(): return strategy.context.actor.chop_tree(
					strategy.context.target_object
				)
			),
		]
	)


func get_clazz(): return "ChopTreeAction"


func is_valid() -> bool:
	return SceneManager.get_elements("tree").size() > 0


func get_cost(blackboard) -> int:
	if blackboard.position:
		var closest_tree = SceneManager.get_closest_element("tree", blackboard)
		return int(closest_tree.position.distance_to(blackboard.position) / 5)
	return 5


func perform(actor, delta) -> bool:
	return strategy.execute(actor, delta)
