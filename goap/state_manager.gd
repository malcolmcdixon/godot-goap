extends Node
class_name StateManager


const NO_KEY_MAPPING = -1

signal created(key: Goap.States, value: Variant)
signal updated(key: Goap.States, value: Variant)
signal erased(key: Goap.States, value: Variant)
# emitted for new and updated key/value pairs
signal changed(key: Goap.States, value: Variant)
signal cleared

static var _state_key_mappings: Dictionary = {}
var _states: Dictionary = {}


static func _static_init() -> void:
	for state_key in Goap.States.keys():
		_state_key_mappings[state_key.to_lower()] = Goap.States[state_key]


func _init(states: Array[GoapState] = []) -> void:
	for state in _states:
		pass
	for key in _state_key_mappings:
		prints(key, _state_key_mappings[key])


func _set(key: StringName, value: Variant) -> bool:
	var mapped_key: int = _get_mapped_key(key)
	if not mapped_key:
		return false
	var exists: bool = _states.has(mapped_key)
	_states[mapped_key] = GoapState.new(mapped_key, value)
	if exists:
		updated.emit(mapped_key, value)
	else:
		created.emit(mapped_key, value)
	changed.emit(key, value)
	return true


func _get(key: StringName) -> Variant:
	# returns null if key does not exist
	var mapped_key: int = _get_mapped_key(key)
	if mapped_key == NO_KEY_MAPPING:
		return null
	return get_or_default(mapped_key)


func _to_string() -> String:
	var result: String = "{"
	for key: int in _states.keys():
		var value = _states[key]
		result += "\n %s: %s" % [key, value]
	result += "\n}"
	return result


func _get_mapped_key(key: StringName) -> int:
	assert(_state_key_mappings.has(key), \
		"Invalid key: %s. Ensure it exists in Goap.States" % key)
	return _state_key_mappings[key]


func get_or_default(key: Goap.States, default: Variant = null) -> Variant:
	if _states.has(key):
		var state: GoapState = _states.get(key, default) as GoapState
		return state.value
	else:
		return default


func clear() -> void:
	_states.clear()
	cleared.emit()
