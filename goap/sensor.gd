class_name GoapSensor
extends RefCounted

var _agent: GoapAgent
var _connection: SignalConnection
var _effects: Array[GoapState]

var connection: SignalConnection:
	get:
		return _connection


func _init(
	agent: GoapAgent,
	init_connection: SignalConnection,
	effects: Array[GoapState]
) -> void:
	_agent = agent
	_connection = init_connection
	_effects = effects

	_connection.connect_signal(self._on_signal_triggered)


func reconnect(node: Node) -> void:
	if not _connection.connected:
		_connection.set_signal_emitter(node)


#
# Derived classes should override this method
#
func _on_signal_triggered(_args: Variant = null) -> void:
	pass
