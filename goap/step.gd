class_name  GoapStep
extends RefCounted


var action: GoapAction
var cost: int  = 0
var desired_state: Array[GoapState]
var blackboard: Array[GoapState]


func _init( \
	step_action: GoapAction, \
	step_cost: int,
	step_desired_state: Array[GoapState], \
	step_blackboard: Array[GoapState]
) -> void:
	self.action = step_action
	self.cost = step_cost
	self.desired_state = step_desired_state
	self.blackboard = step_blackboard


func duplicate(deep: bool = false) -> GoapStep:
	return GoapStep.new(
		action,
		cost,
		desired_state.duplicate(deep),
		blackboard.duplicate(deep)
	)
