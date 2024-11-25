extends GoapGoal

class_name KeepFedGoal


func _init() -> void:
	desired_state = GoapState.new(Goap.States.IS_HUNGRY, false)


func get_clazz(): return "KeepFedGoal"

# This is not a valid goal when hunger is less than 50.
func is_valid() -> bool:
	#return Goap.state.get_or_default("hunger", 0)  > 50 and SceneManager.get_elements("food").size() > 0
	return Goap.world_state.get_or_default(Goap.States.HUNGER, 0)  > 50 and SceneManager.get_elements("food").size() > 0


func priority() -> int:
	#return 1 if Goap.state.get_or_default("hunger", 0) < 75 else 2
	return 1 if Goap.world_state.get_or_default(Goap.States.HUNGER, 0) < 75 else 2


func get_desired_state() -> Dictionary:
	return {
		"is_hungry": false
	}
