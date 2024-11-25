extends RefCounted
class_name GoapState


var _key: Goap.States
var _value: Variant

var key: Goap.States:
	get:
		return _key


var value: Variant:
	set(value):
		_value = value
	get:
		return _value


func _init(key: Goap.States, value: Variant) -> void:
	_key = key
	_value = value


func equals(other: GoapState) -> bool:
	return other != null and _key == other.key and _value == other.value
