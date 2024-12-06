class_name AvoidEnemyGoal
extends GoapGoal


func _init() -> void:
	desired_state = GoapState.new(Goap.States.NEAR_ENEMY, false)


func get_clazz(): return "AvoidEnemyGoal"

func is_valid() -> bool:
	return not Goap.world_state.protected and \
		Goap.world_state.get_or_default(Goap.States.NEAR_ENEMY, true)


func priority() -> int:
	return 11
