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


func _init(init_key: Goap.States, init_value: Variant) -> void:
	_key = init_key
	_value = init_value


func _to_string() -> String:
	return "%s = %s" % [Goap.States.keys()[key], value]


func equals(other: GoapState) -> bool:
	return other != null and _key == other.key and _value == other.value
