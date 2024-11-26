extends GoapGoal

class_name KeepFirepitBurningGoal


func _init() -> void:
	self.desired_state = GoapState.new(Goap.States.HAS_FIREPIT, true)


func get_clazz(): return "KeepFirepitBurningGoal"


func is_valid() -> bool:
	return SceneManager.get_elements("firepit").size() == 0


func priority() -> int:
	return 1
