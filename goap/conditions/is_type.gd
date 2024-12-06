class_name IsTypeGoapCondition
extends GoapCondition


@export var target_type: String


func _init(init_name: StringName, type: String) -> void:
	super._init(init_name)
	target_type = type


func evaluate(args: Variant) -> bool:
	if not args is Node:
		push_warning("IsTypeGoapCondition.evaluate: Argument is not a Node")
		return false
	
	var node = args as Node
	
	# Ensure the node and its script are valid before evaluating
	if not is_instance_valid(node):
		push_warning("IsTypeGoapCondition.evaluate: Invalid node passed")
		return false
		
	if target_type == "Firepit":
		pass

	var script: Script = node.get_script()
	if script:
		return target_type == script.get_global_name()
	
	return false
