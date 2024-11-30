class_name BuildFirepitAction
extends GoapAction


const FIREPIT: PackedScene = preload("res://scenes/firepit.tscn")


func _init() -> void:
	preconditions.append(GoapState.new(Goap.States.HAS_FIREPIT, false))
	preconditions.append(GoapState.new(Goap.States.HAS_WOOD, true))

	effects.append(GoapState.new(Goap.States.HAS_FIREPIT, true))
	effects.append(GoapState.new(Goap.States.HAS_WOOD, false))

	strategy = MultiActionStrategy.new(
		[
			MoveToTargetActionStrategy.new("firepit_spot", 20.0),
			PutDownActionStrategy.new(FIREPIT),
		]
	)

func get_clazz(): return "BuildFirepitAction"


func get_cost(_blackboard) -> int:
	return 1


func perform(actor, delta) -> bool:
	return strategy.execute(actor, delta)
