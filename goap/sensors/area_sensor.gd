class_name AreaGoapSensor
extends GoapSensor


var _rules: Dictionary = {}


func _init(
	agent: GoapAgent,
	init_connection: SignalConnection,
	rules: Dictionary = {}
) -> void:
	_rules = rules
	super._init(agent, init_connection, [])


# Add a new rule
func add_rule(rule: GoapRule) -> void:
	var name: StringName = rule.name
	if _rules.has(name):
		push_warning("Rule with name '%s' already exists" % name)
		return

	_rules[name] = rule
	prints("Added rule:", name)


# Remove an existing rule
func remove_rule(name: StringName) -> void:
	if not _rules.has(name):
		push_warning("No rule found with name '%s'" % name)
		return

	_rules.erase(name)
	prints("Removed rule:", name)


func _on_signal_triggered(args: Variant = null) -> void:
	if not args is Node2D:
		push_warning("AreaGoapSensor._on_signal_triggered: \
			Passed argument is not a Node2D")
		return
	
	var node: Node2D = args as Node2D
	prints("Area sensor triggered by", node.name)

	for rule: GoapRule in _rules.values():
		if rule.condition.is_valid() and rule.condition.call(node):
			Goap.world_state.apply_effects(rule.effects)
