class_name GoapSensor
extends RefCounted

var _agent: GoapAgent
var _connection: SignalConnection
var _rules: Dictionary = {}

var connection: SignalConnection:
	get:
		return _connection


func _init(
	agent: GoapAgent,
	init_connection: SignalConnection,
) -> void:
	_agent = agent
	_connection = init_connection

	_connection.connect_signal(self._on_signal_triggered)


func reconnect(node: Node) -> void:
	if not _connection.connected:
		_connection.set_signal_emitter(node)


# Add a new rule
func add_rule(rule: GoapRule) -> void:
	var name: StringName = rule.name
	if _rules.has(name):
		push_warning("Rule with name '%s' already exists" % name)
		return

	_rules[name] = rule


# Remove an existing rule
func remove_rule(name: StringName) -> void:
	if not _rules.has(name):
		push_warning("No rule found with name '%s'" % name)
		return

	_rules.erase(name)


#
# Derived classes should override this method
#
func _on_signal_triggered(_args: Variant = null) -> void:
	pass
