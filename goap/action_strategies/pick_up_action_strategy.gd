class_name PickUpActionStrategy
extends ActionStrategy


var _object: Node
var _free: bool


func _init(
	object: Node = null,
	free: bool = false
) -> void:
	_object = object
	_free = free


func _start(_actor: Node) -> bool:
	if not _object:
		if not self.context.target_object:
			push_error("PickUpActionStrategy._start: 'target object' must be set")
			return false
		else:
			_object = self.context.target_object
	
	#### CONTEXT FOR OBJECT PICKED UP ####
	self.context.item_picked_up = _object

	return true


func _execute(_actor: Node, _delta: float) -> bool:
	if _free:
		_object.queue_free()

	return true
