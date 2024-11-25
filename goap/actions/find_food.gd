extends GoapAction

class_name FindFoodAction


func _init() -> void:
	effects.append(GoapState.new(Goap.States.IS_HUNGRY, false))


func get_clazz(): return "FindFoodAction"


func get_cost(_blackboard) -> int:
	return 1


func get_preconditions() -> Dictionary:
	return {}


func get_effects() -> Dictionary:
	return {
		"is_hungry": false
	}


func perform(actor, delta) -> bool:
	var closest_food = SceneManager.get_closest_element("food", actor)

	if closest_food == null:
		return false

	if closest_food.position.distance_to(actor.position) < 5:
		#Goap.state.hunger -= closest_food.nutrition
		Goap.world_state.hunger -= closest_food.nutrition
		closest_food.queue_free()
		return true

	actor.move_to(actor.position.direction_to(closest_food.position), delta)
	return false
