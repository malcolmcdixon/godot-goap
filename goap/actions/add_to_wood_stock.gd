extends GoapAction

class_name AddToWoodStockAction


const Woodstock = preload("res://scenes/wood_stock.tscn")


func _init(target: String, distance_offset: float) -> void:
	preconditions.append(GoapState.new(Goap.States.HAS_WOOD, true))
	effects.append(GoapState.new(Goap.States.IS_STOCKPILING, true))
	effects.append(GoapState.new(Goap.States.HAS_WOOD, false))
	strategy = MoveToTargetActionStrategy.new(target, distance_offset)


func get_clazz(): return "AddToWoodStockAction"


func is_valid() -> bool:
	return SceneManager.get_elements("wood_stock_spot").size() > 0


func get_cost(blackboard) -> int:
	if blackboard.position:
		var closest_wood_stock_spot = SceneManager.get_closest_element("wood_stock_spot", blackboard)
		return int(closest_wood_stock_spot.position.distance_to(blackboard.position) / 8)
	return 3


func perform(actor, delta) -> bool:
	if strategy.execute(actor, delta):
		var wood_stock = Woodstock.instantiate()
		actor.get_parent().get_node("WoodStocks").add_child(wood_stock)
		wood_stock.position = strategy.target_position
		strategy.target_object.queue_free()
		Goap.world_state.is_stockpiling = true
		Goap.world_state.has_wood = false
		return true

	return false
