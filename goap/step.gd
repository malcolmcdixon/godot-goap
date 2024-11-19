#
# This is a node within the plan
# containing the action and its
# desired state and child actions
#

extends RefCounted
class_name GoapStep


var action: GoapAction
var desired_state: Dictionary
var next_steps: Array[GoapStep]

# Constructor to initialize the step with an action and state
func _init(action: GoapAction, state: Dictionary) -> void:
	self.action = action
	self.state = state
	self.next_steps = []


func add_next_step(next_step: GoapStep) -> void:
	next_steps.append(next_step)
