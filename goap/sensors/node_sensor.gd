class_name NodeGoapSensor
extends GoapSensor


func _on_signal_triggered(args: Variant = null) -> void:
	if not args is Node:
		push_warning("NodeGoapSensor._on_signal_triggered: \
			Passed argument is not a Node")
		return
	
	var node: Node = args as Node

	for rule: GoapRule in _rules.values():
		rule.process(node)
