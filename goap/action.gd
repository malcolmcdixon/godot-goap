#
# Action Contract
#
class_name GoapAction
extends Node


#
# Action requirements.
# Example: preconditions.append(GoapState.new(Goap.States.HAS_WOOD, true))
#
var preconditions: Array[GoapState] # Add preconditions in _init()

#
# What conditions this action satisfies.
# Example: effects.append(GoapState.new(Goap.States.HAS_FIREPIT, true))
#
var effects: Array[GoapState] # Add effects in _init()


#
# Use strategy pattern to use composable execution logic
#
var strategy: ActionStrategy


func get_clazz(): return "GoapAction"


#
# This indicates if the action should be considered or not.
#
# Currently I'm using this method only during planning, but it could
# also be used during execution to abort the plan in case the world state
# does not allow this action anymore.
#
func is_valid() -> bool:
	return true


#
# Action Cost. This is a function so it handles situational costs, when the world
# state is considered when calculating the cost.
#
# Check "./actions/chop_tree.gd" for a situational cost example.
#
func get_cost(_blackboard) -> int:
	return 1000

#
# Action implementation called on every loop.
# "actor" is the NPC using the AI
# "delta" is the time in seconds since last loop.
#
# Returns true when the task is complete.
#
# Check "./actions/chop_tree.gd" for example.
#
# I decided to have actions owning their logic, but this
# is up to you. You could have another script to handle this
# or even let your NPC decide how to handle the action. In other words,
# your NPC could just receive the action name and decide what to do.
#
func perform(_actor, _delta) -> bool:
	return false


func apply_effects(states :StateManager) -> void:
	for effect in effects:
		states.update(effect.copy())
