extends GoapAction

class_name CollectFromWoodStockAction


func _init() -> void:
	effects.append(GoapState.new(Goap.States.HAS_WOOD, true))


func get_clazz(): return "CollectFromWoodStockAction"


func is_valid() -> bool:
	return SceneManager.get_elements("wood_stock").size() > 0


func get_cost(blackboard) -> int:
	if blackboard.position:
		var closest_wood_stock = SceneManager.get_closest_element("wood_stock", blackboard)
		return int(closest_wood_stock.position.distance_to(blackboard.position) / 7)
	return 4


func perform(actor, delta) -> bool:
	var closest_stock = SceneManager.get_closest_element("wood_stock", actor)

	if closest_stock:
		if closest_stock.position.distance_to(actor.position) < 10:
			closest_stock.queue_free()
			Goap.world_state.has_wood = true
			return true
		else:
			actor.move_to(actor.position.direction_to(closest_stock.position), delta)

	return false
