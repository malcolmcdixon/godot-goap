class_name GoToFirepitAction
extends GoapAction


func _init() -> void:
	preconditions.append(GoapState.new(Goap.States.HAS_WOOD, true))

	effects.append(GoapState.new(Goap.States.AT_FIREPIT, true))

	strategy = MoveToTargetActionStrategy.new("firepit_spot", 20.0)


func get_clazz(): return "GoToFirepitAction"


func get_cost(blackboard) -> int:
	if blackboard.position:
		var closest_wood_stock = SceneManager.get_closest_element("firepit_spot", blackboard)
		return int(closest_wood_stock.position.distance_to(blackboard.position) / 8)
	return 3


func perform(actor, delta) -> bool:
	return strategy.execute(actor, delta)
