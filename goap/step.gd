#
# This is a node within the plan
# containing the action and its
# desired state and child actions
#

extends RefCounted
class_name GoapStep


var action: GoapAction
var state: Dictionary
var next_steps: Array[GoapStep]
var cost: int


# Constructor to initialize the step with an action and state
func _init(step_action: GoapAction, step_state: Dictionary) -> void:
	self.action = step_action
	self.state = step_state
	self.next_steps = []


func add_next_step(next_step: GoapStep) -> void:
	next_steps.append(next_step)
