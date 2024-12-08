class_name GoapCondition
extends Node


@export var condition_name: StringName


func _init(init_name: StringName) -> void:
	condition_name = init_name


#
# Derived classes should override this method
#
func evaluate(_args: Variant) -> bool:
	return false
