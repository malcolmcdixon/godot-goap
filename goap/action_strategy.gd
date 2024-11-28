extends RefCounted
class_name ActionStrategy


var _started: bool = false


func execute(actor: Node, delta: float) -> bool:
	if not _started:
		if not _start_internal(actor):
			return false

	if _execute(actor, delta):
		return _stop_internal(actor)
	
	return false


func _start_internal(actor: Node) -> bool:
	_started = true
	return _start(actor)


func _stop_internal(actor: Node) -> bool:
	_started = false
	return _stop(actor)


#
# Derived classes to override these methods
# Only _execute needs to be overridden
#
func _start(actor: Node) -> bool:
	return true


func _execute(actor: Node, delta: float) -> bool:
	return true


func _stop(actor: Node) -> bool:
	return true
