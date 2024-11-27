extends GoapAction

class_name BuildFirepitAction

const Firepit = preload("res://scenes/firepit.tscn")


func _init() -> void:
	preconditions.append(GoapState.new(Goap.States.HAS_WOOD, true))
	effects.append(GoapState.new(Goap.States.HAS_FIREPIT, true))
	effects.append(GoapState.new(Goap.States.HAS_WOOD, false))

func get_clazz(): return "BuildFirepitAction"


func get_cost(_blackboard) -> int:
	return 1


func perform(actor, delta) -> bool:
	var _closest_spot = SceneManager.get_closest_element("firepit_spot", actor)

	if _closest_spot == null:
		return false

	if _closest_spot.position.distance_to(actor.position) < 20:
			var firepit = Firepit.instantiate()
			actor.get_parent().add_child(firepit)
			firepit.position = _closest_spot.position
			firepit.z_index = _closest_spot.z_index
			Goap.world_state.has_wood = false
			Goap.world_state.has_firepit = true
			return true

	actor.move_to(actor.position.direction_to(_closest_spot.position), delta)

	return false
