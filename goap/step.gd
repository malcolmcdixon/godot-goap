extends RefCounted
class_name  GoapStep


var action: GoapAction
var cost: int  = 0
var desired_state: Dictionary
var blackboard: Dictionary


func _init( \
	step_action: GoapAction, \
	step_cost: int,
	step_desired_state: Dictionary, \
	step_blackboard: Dictionary
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
