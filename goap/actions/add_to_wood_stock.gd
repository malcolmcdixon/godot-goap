extends GoapAction

class_name AddToWoodStockAction


const Woodstock = preload("res://scenes/wood_stock.tscn")


func _init() -> void:
	preconditions.append(GoapState.new(Goap.States.HAS_WOOD, true))
	effects.append(GoapState.new(Goap.States.IS_STOCKPILING, true))
	effects.append(GoapState.new(Goap.States.HAS_WOOD, false))

func get_clazz(): return "AddToWoodStockAction"


func is_valid() -> bool:
	return SceneManager.get_elements("wood_stock_spot").size() > 0


func get_cost(blackboard) -> int:
	if blackboard.position:
		var closest_wood_stock_spot = SceneManager.get_closest_element("wood_stock_spot", blackboard)
		return int(closest_wood_stock_spot.position.distance_to(blackboard.position) / 8)
	return 3


func perform(actor, delta) -> bool:
	var _closest_spot = SceneManager.get_closest_element("wood_stock_spot", actor)

	if _closest_spot == null:
		return false

	if _closest_spot.position.distance_to(actor.position) < 10:
			var wood_stock = Woodstock.instantiate()
			actor.get_parent().get_node("WoodStocks").add_child(wood_stock)
			wood_stock.position = _closest_spot.position
			wood_stock.z_index = _closest_spot.z_index
			_closest_spot.queue_free()
			Goap.world_state.has_wood = false
			Goap.world_state.is_stockpiling = true
			return true

	actor.move_to(actor.position.direction_to(_closest_spot.position), delta)

	return false
