class_name PutDownActionStrategy
extends ActionStrategy


var _object: PackedScene
var _parent: Node


func _init(
	object: PackedScene,
	parent: Node = null
) -> void:
	_object = object
	_parent = parent


func _start(actor: Node) -> bool:
	if not self.context.target_object:
		push_error("PutDownActionStrategy._start: 'target object' must be set")
		return false

	if not _parent:
		_parent = actor.get_parent()

	return true


func _execute(_actor: Node, _delta: float) -> bool:
	var object: Node = _object.instantiate()
	object.position = self.context.target_object.position
	_parent.add_child(object)

	return true
