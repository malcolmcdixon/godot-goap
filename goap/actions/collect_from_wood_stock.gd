extends GoapAction

class_name CollectFromWoodStockAction


func _init() -> void:
	preconditions.append(GoapState.new(Goap.States.HAS_WOOD, false))
	preconditions.append(GoapState.new(Goap.States.IS_STOCKPILING, false))
	effects.append(GoapState.new(Goap.States.HAS_WOOD, true))


func get_clazz(): return "CollectFromWoodStockAction"


func is_valid() -> bool:
	return SceneManager.get_elements("wood_stock").size() > 0 # and \
		#not Goap.world_state.get_or_default(Goap.States.IS_STOCKPILING, false)


func get_cost(blackboard) -> int:
	if blackboard.position:
		var closest_wood_stock = SceneManager.get_closest_element("wood_stock", blackboard)
		return int(closest_wood_stock.position.distance_to(blackboard.position) / 8)
	return 3


func perform(actor, delta) -> bool:
	var closest_stock = SceneManager.get_closest_element("wood_stock", actor)

	if closest_stock:
		if closest_stock.position.distance_to(actor.position) < 10:
			# Add a marker for a place to put wood
			var wood_stock_spot = Marker2D.new()
			wood_stock_spot.position = closest_stock.position
			wood_stock_spot.add_to_group("wood_stock_spot")
			actor.get_parent().get_node("WoodStocks").add_child(wood_stock_spot)
			closest_stock.queue_free()
			Goap.world_state.has_wood = true
			return true
		else:
			actor.move_to(actor.position.direction_to(closest_stock.position), delta)

	return false
