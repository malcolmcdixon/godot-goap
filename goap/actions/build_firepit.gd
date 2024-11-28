extends GoapAction

class_name BuildFirepitAction

const Firepit = preload("res://scenes/firepit.tscn")


func _init() -> void:
	preconditions.append(GoapState.new(Goap.States.HAS_WOOD, true))
	effects.append(GoapState.new(Goap.States.HAS_FIREPIT, true))
	effects.append(GoapState.new(Goap.States.HAS_WOOD, false))
	strategy = MoveToTargetStrategy.new()
	strategy.target_object = "firepit_spot"
	strategy.distance_offset = 20.0


func get_clazz(): return "BuildFirepitAction"


func get_cost(_blackboard) -> int:
	return 1


func perform(actor, delta) -> bool:
	if strategy.execute(actor, delta):
			var firepit = Firepit.instantiate()
			firepit.position = strategy.target_position
			actor.get_parent().add_child(firepit)
			Goap.world_state.has_wood = false
			Goap.world_state.has_firepit = true
			return true

	return false
