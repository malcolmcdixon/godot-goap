class_name ActionStrategy
extends RefCounted


var _started: bool = false
var context: StrategyContext = StrategyContext.new()


func execute(actor: Node, delta: float) -> bool:
	# Make actor accessible to all strategies through the context
	context.actor = actor
	
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
func _start(_actor: Node) -> bool:
	return true


func _execute(_actor: Node, _delta: float) -> bool:
	return true


func _stop(_actor: Node) -> bool:
	return true
