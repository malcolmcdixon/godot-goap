extends GoapAction

class_name FindFoodAction


func _init() -> void:
	effects.append(GoapState.new(Goap.States.IS_HUNGRY, false))
	strategy = MoveToTargetActionStrategy.new("food", 5.0)


func get_clazz(): return "FindFoodAction"


func get_cost(_blackboard) -> int:
	return 1


func perform(actor, delta) -> bool:
	if strategy.execute(actor, delta):
		var food = strategy.target_object
		Goap.world_state.hunger -= food.nutrition
		food.queue_free()
		if Goap.world_state.hunger <= 50:
			Goap.world_state.is_hungry = false
		return true

	return false
