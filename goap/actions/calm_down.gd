extends GoapAction

class_name CalmDownAction


func _init() -> void:
	preconditions.append(GoapState.new(Goap.States.PROTECTED, true))
	effects.append(GoapState.new(Goap.States.IS_FRIGHTENED, false))


func get_clazz(): return "CalmDownAction"


func get_cost(_blackboard) -> int:
	return 1


func get_preconditions() -> Dictionary:
	return {
		"protected": true
	}


func get_effects() -> Dictionary:
	return {
		"is_frightened": false
	}


func perform(actor, _delta) -> bool:
	return actor.calm_down()
