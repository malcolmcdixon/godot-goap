class_name GoapRule
extends RefCounted


var name: StringName
var condition: GoapCondition
var effects: Array[GoapState]


func _init(
	init_name: StringName,
	init_condition: GoapCondition,
	init_effects: Array[GoapState]
) -> void:
	self.name = init_name
	self.condition = init_condition
	self.effects = init_effects


func process(input: Variant) -> void:
	if condition and condition.evaluate(input):
		Goap.world_state.apply_effects(effects)
