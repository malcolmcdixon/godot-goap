class_name ValueGoapSensor
extends GoapSensor


func _on_signal_triggered(args: Variant = null) -> void:
	if not (args is int or args is float):
		push_warning("AreaGoapSensor._on_signal_triggered: \
			Passed argument is not an int or float")
		return
	
	var value
	
	match typeof(args):
		TYPE_INT:
			value = args as int
		TYPE_FLOAT:
			value = args as float

	for rule: GoapRule in _rules.values():
		rule.process(value)
