class_name SignalConnection
extends RefCounted


var _signal_emitter: Node
var _signal_name: StringName
var _callback: Callable
# Function to determine if passed node is relevant
var _object_matcher: Callable 


var connected: bool:
	get:
		return _signal_emitter and _signal_emitter.is_connected(_signal_name, _callback)


func _init(
	signal_name: StringName,
	signal_emitter: Node = null,
	object_matcher: Callable = Callable()
) -> void:
	_signal_emitter = signal_emitter
	_signal_name = signal_name
	_object_matcher = object_matcher

	# Ensure static connections have a valid emitter
	if not _signal_emitter and not _object_matcher:
		push_error("SignalConnection: A signal emitter must be provided if no object matcher is specified.")


func connect_signal(callback: Callable) -> bool:
	if _callback and connected:
		return true

	_callback = callback
	
	if _signal_emitter and _signal_emitter.has_signal(_signal_name):
		var result: int = _signal_emitter.connect(_signal_name, _callback)
		if result == OK:
			return true
		
		push_error("SignalConnection.connect_signal: \
			Failed to connect signal '%s'" % _signal_name)

	return false


func set_signal_emitter(node: Node) -> void:
	if _object_matcher and _object_matcher.is_valid() and _object_matcher.call(node):
		_signal_emitter = node
		_signal_emitter.tree_exited.connect(_on_signal_emitter_tree_exited)
		connect_signal(_callback)


func _on_signal_emitter_tree_exited() -> void:
	# Unreference _signal_emitter when node leaves scene tree
	_signal_emitter = null
