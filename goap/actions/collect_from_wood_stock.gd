extends GoapAction

class_name CollectFromWoodStockAction


func _init(target: String, distance_offset: float) -> void:
	preconditions.append(GoapState.new(Goap.States.HAS_WOOD, false))
	preconditions.append(GoapState.new(Goap.States.IS_STOCKPILING, false))
	effects.append(GoapState.new(Goap.States.HAS_WOOD, true))
	strategy = MoveToTargetActionStrategy.new(target, distance_offset)


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
	if strategy.execute(actor, delta):
		# Add a marker for a place to put wood
		var wood_stock_spot = Marker2D.new()
		wood_stock_spot.position = strategy.target_position
		wood_stock_spot.add_to_group("wood_stock_spot")
		actor.get_parent().get_node("WoodStocks").add_child(wood_stock_spot)
		strategy.target_object.queue_free()
		return true

	return false
