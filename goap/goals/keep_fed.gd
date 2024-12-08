class_name KeepFedGoal
extends GoapGoal


func _init() -> void:
	desired_state = GoapState.new(Goap.States.IS_HUNGRY, false)


func get_clazz(): return "KeepFedGoal"


#
# This is a valid goal when hungry (hunger is > 50) and
# there are food elements left
#
func is_valid() -> bool:
	return Goap.world_state.is_hungry and \
		SceneManager.get_elements("food").size() > 0


func priority() -> int:
	if Goap.world_state.is_hungry and Goap.world_state.near_food:
		return 9
	elif Goap.world_state.hunger < 75:
		return 2
	
	return 3
