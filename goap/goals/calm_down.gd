extends GoapGoal

class_name CalmDownGoal

func get_clazz(): return "CalmDownGoal"

func is_valid() -> bool:
	return Goap.state.get_or_default("is_frightened", false)


func priority() -> int:
	return 10


func get_desired_state() -> Dictionary:
	return {
		"is_frightened": false
	}
