class_name DoActionStrategy
extends ActionStrategy


var _do_func: Callable


func _init(do_func: Callable) -> void:
	if not do_func.is_valid():
		push_error("DoActionStrategy._init: Invalid Callable passed.")
		return

	_do_func = do_func


func _execute(_actor: Node, _delta: float) -> bool:
	if _do_func:
		var result: Variant = _do_func.call()
		if result == null:
			# No return value means success
			return true
		elif result is bool:
			# Explicit boolean return
			return result
		else:
			# Unexpected return type
			push_error("DoActionStrategy._execute: \
				Callable returned a non-bool value:", result)
			return false
	return true
