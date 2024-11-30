extends GoapAction

class_name CollectFromWoodStockAction


var WOOD_STOCK_SPOT: PackedScene = preload("res://scenes/wood_stock_spot.tscn")


func _init() -> void:
	preconditions.append(GoapState.new(Goap.States.HAS_WOOD, false))
	preconditions.append(GoapState.new(Goap.States.IS_STOCKPILING, false))

	effects.append(GoapState.new(Goap.States.HAS_WOOD, true))

	strategy = MultiActionStrategy.new(
		[
			# Move to nearest wood stock
			MoveToTargetActionStrategy.new("wood_stock", 10.0),
			# Pick up wood
			PickUpActionStrategy.new(null, true),
			# Add a marker for a place to put wood stock
			PutDownActionStrategy.new(WOOD_STOCK_SPOT),
		]
	)


func get_clazz(): return "CollectFromWoodStockAction"


func is_valid() -> bool:
	return SceneManager.get_elements("wood_stock").size() > 0


func get_cost(blackboard) -> int:
	if blackboard.position:
		var closest_wood_stock = SceneManager.get_closest_element("wood_stock", blackboard)
		return int(closest_wood_stock.position.distance_to(blackboard.position) / 8)
	return 3


func perform(actor, delta) -> bool:
	return strategy.execute(actor, delta)
