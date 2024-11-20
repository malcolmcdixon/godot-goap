extends RefCounted
class_name ObservableDictionary


signal created(key: Variant, value: Variant)
signal updated(key: Variant, value: Variant)
signal erased(key: Variant, value: Variant)
# emitted for new and updated key/value pairs
signal changed(key: Variant, value: Variant)
signal cleared

var _dict: Dictionary = {}


func _set(key: StringName, value: Variant) -> bool:
	var exists: bool = _dict.has(key)
	_dict[key] = value
	if exists:
		updated.emit(key, value)
	else:
		created.emit(key, value)
	changed.emit(key, value)
	return true


func _get(key: StringName) -> Variant:
	# returns null if key does not exist
	return _dict.get(key)


func get_or_default(key: StringName, default: Variant = null) -> Variant:
	return _dict.get(key, default)


func clear() -> void:
	_dict.clear()
	cleared.emit()
