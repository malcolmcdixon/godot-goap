extends GoapAction

class_name BuildFirepitAction

const Firepit = preload("res://scenes/firepit.tscn")


func _init(target: String, distance_offset: float) -> void:
	preconditions.append(GoapState.new(Goap.States.HAS_FIREPIT, false))
	preconditions.append(GoapState.new(Goap.States.HAS_WOOD, true))
	effects.append(GoapState.new(Goap.States.HAS_FIREPIT, true))
	effects.append(GoapState.new(Goap.States.HAS_WOOD, false))
	strategy = MoveToTargetActionStrategy.new(target, distance_offset)


func get_clazz(): return "BuildFirepitAction"


func get_cost(_blackboard) -> int:
	return 1


func perform(actor, delta) -> bool:
	if strategy.execute(actor, delta):
			var firepit = Firepit.instantiate()
			firepit.position = strategy.target_position
			actor.get_parent().add_child(firepit)
			return true

	return false
