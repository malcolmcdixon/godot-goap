extends GoapGoal

class_name KeepFirepitBurningGoal

func get_clazz(): return "KeepFirepitBurningGoal"


func is_valid() -> bool:
	return SceneManager.get_elements("firepit").size() == 0


func priority() -> int:
	return 1


func get_desired_state() -> Dictionary:
	return {
		"has_firepit": true
	}
