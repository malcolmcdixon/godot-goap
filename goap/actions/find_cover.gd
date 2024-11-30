extends GoapAction

class_name FindCoverAction


func _init() -> void:
	preconditions.append(GoapState.new(Goap.States.IS_FRIGHTENED, true))

	effects.append(GoapState.new(Goap.States.PROTECTED, true))

	strategy = MoveToTargetActionStrategy.new("cover", 1.0)


func get_clazz(): return "FindCoverAction"


func get_cost(_blackboard) -> int:
	return 1


func perform(actor, delta) -> bool:
	return strategy.execute(actor, delta)
