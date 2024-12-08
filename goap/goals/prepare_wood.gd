class_name PrepareWoodGoal
extends GoapGoal


func _init() -> void:
	desired_state = GoapState.new(Goap.States.AT_FIREPIT, true)


func get_clazz(): return "PrepareWoodGoal"


func is_valid() -> bool:
	return not Goap.world_state.at_firepit and Goap.world_state.prepare_wood


func priority() -> int:
	return 2
