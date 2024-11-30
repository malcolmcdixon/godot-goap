extends GoapAction

class_name CalmDownAction


func _init(duration: float) -> void:
	preconditions.append(GoapState.new(Goap.States.PROTECTED, true))

	effects.append(GoapState.new(Goap.States.IS_FRIGHTENED, false))
	effects.append(GoapState.new(Goap.States.PROTECTED, false))

	strategy = TimerActionStrategy.new(duration)


func get_clazz(): return "CalmDownAction"


func get_cost(_blackboard) -> int:
	return 1


func perform(actor, delta) -> bool:
	return strategy.execute(actor, delta)
