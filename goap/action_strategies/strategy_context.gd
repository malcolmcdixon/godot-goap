class_name StrategyContext
extends RefCounted


var _context: Dictionary = {}
var context: Dictionary:
	get:
		return _context


func _set(key: StringName, value: Variant) -> bool:
	_context[key] = value
	return true


func _get(key: StringName) -> Variant:
	if _context.has(key):
		return _context[key]
	
	return null
