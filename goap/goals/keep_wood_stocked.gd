extends GoapGoal

class_name KeepWoodStockedGoal


func _init() -> void:
	desired_state = GoapState.new(Goap.States.IS_STOCKPILING, true)


func get_clazz(): return "KeepWoodStockedGoal"

# This is not a valid goal when there are no free wood stocks spots
func is_valid() -> bool:
	return SceneManager.get_elements("wood_stock_spot").size() > 0


func priority() -> int:
	return 1