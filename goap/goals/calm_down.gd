extends GoapGoal

class_name CalmDownGoal


func _init() -> void:
	desired_state = GoapState.new(Goap.States.IS_FRIGHTENED, false)


func get_clazz(): return "CalmDownGoal"

func is_valid() -> bool:
	return Goap.world_state.get_or_default(Goap.States.IS_FRIGHTENED, false)


func priority() -> int:
	return 10
