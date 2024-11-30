class_name FindFoodAction
extends GoapAction


func _init() -> void:
	effects.append(GoapState.new(Goap.States.IS_HUNGRY, false))

	strategy = MultiActionStrategy.new(
		[
			# Move to nearest food
			MoveToTargetActionStrategy.new("food", 5.0),
			# Pick up food
			PickUpActionStrategy.new(null, true),
			# Update hunger world state
			DoActionStrategy.new(
				func(): Goap.world_state.hunger -= \
					strategy.context.target_object.nutrition
			),
		]
	)


func get_clazz(): return "FindFoodAction"


func get_cost(_blackboard) -> int:
	return 1


func perform(actor, delta) -> bool:
	return strategy.execute(actor, delta)
