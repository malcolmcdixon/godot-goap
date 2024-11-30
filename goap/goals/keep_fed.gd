class_name KeepFedGoal
extends GoapGoal


func _init() -> void:
	desired_state = GoapState.new(Goap.States.IS_HUNGRY, false)


func get_clazz(): return "KeepFedGoal"

# This is not a valid goal when hunger is less than 50.
func is_valid() -> bool:
	return Goap.world_state.is_hungry and \
		SceneManager.get_elements("food").size() > 0


func priority() -> int:
	return 2 if Goap.world_state.hunger < 75 else 3
