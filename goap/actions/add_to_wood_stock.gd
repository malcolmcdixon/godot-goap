extends GoapAction

class_name AddToWoodStockAction


const WOODSTOCK = preload("res://scenes/wood_stock.tscn")


func _init() -> void:
	preconditions.append(GoapState.new(Goap.States.HAS_WOOD, true))

	effects.append(GoapState.new(Goap.States.IS_STOCKPILING, true))
	effects.append(GoapState.new(Goap.States.HAS_WOOD, false))

	strategy = MultiActionStrategy.new(
		[
			# Move to nearest wood stock
			MoveToTargetActionStrategy.new("wood_stock_spot", 10.0),
			# Add a wood stock object
			PutDownActionStrategy.new(WOODSTOCK),
			# Pick up wood
			PickUpActionStrategy.new(null, true),
		]
	)

func get_clazz(): return "AddToWoodStockAction"


func is_valid() -> bool:
	return SceneManager.get_elements("wood_stock_spot").size() > 0


func get_cost(blackboard) -> int:
	if blackboard.position:
		var closest_wood_stock_spot = SceneManager.get_closest_element("wood_stock_spot", blackboard)
		return int(closest_wood_stock_spot.position.distance_to(blackboard.position) / 8)
	return 3


func perform(actor, delta) -> bool:
	return strategy.execute(actor, delta)
