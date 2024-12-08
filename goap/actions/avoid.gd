class_name AvoidAction
extends GoapAction


func _init() -> void:
	preconditions.append(GoapState.new(Goap.States.NEAR_ENEMY, true))

	effects.append(GoapState.new(Goap.States.NEAR_ENEMY, false))

	strategy = MoveToLocationActionStrategy.new("bearing")


func get_clazz(): return "AvoidAction"


func get_cost(_blackboard) -> int:
	return 0


func perform(actor, delta) -> bool:
	return strategy.execute(actor, delta)
