class_name GoapRule
extends RefCounted


var name: StringName
var condition: Callable
var effects: Array[GoapState]

func _init(
	init_name: StringName,
	init_condition: Callable,
	init_effects: Array[GoapState]
) -> void:
	self.name = init_name
	self.condition = init_condition
	self.effects = init_effects
