#
# This script integrates the actor (NPC) with goap.
# In your implementation you could have this logic
# inside your NPC script.
#
# As good practice, I suggest leaving it isolated like
# this, so it makes re-use easy and it doesn't get tied
# to unrelated implementation details (movement, collisions, etc)
extends Node

class_name GoapAgent

var _goals: Array[GoapGoal]
var _current_goal: GoapGoal
var _current_plan: GoapPlan
var _current_plan_step: int = 0

var _actor: Node
var _blackboard: Dictionary = {}


# Connect to Goap state change signal
func _ready() -> void:
	Goap.state_changed.connect(_on_state_changed)
	

#
# On every loop this script checks if the current goal is still
# the highest priority. if it's not, it requests the action planner a new plan
# for the new high priority goal.
#
func _process(delta: float) -> void:
	
	var goal: GoapGoal = _get_best_goal()
	if _current_goal == null or goal != _current_goal:
		var start_time: float = Time.get_ticks_usec()
	# You can set in the blackboard any relevant information you want to use
	# when calculating action costs and status. I'm not sure here is the best
	# place to leave it, but I kept here to keep things simple.
		_blackboard["position"] = _actor.position
		_current_goal = goal
		_current_plan = Goap.get_action_planner().get_plan(_current_goal, _blackboard)
		_current_plan_step = 0
		prints("Time Elapsed for planning goal:", Time.get_ticks_usec() - start_time)
	else:
		_follow_plan(_current_plan, delta)

	

func init(actor: Node, goals: Array[GoapGoal]) -> void:
	_actor = actor
	_goals = goals


# Update the blackboard with the specific state change
func _on_state_changed(state_name: StringName, state_value: Variant) -> void:
	_blackboard[state_name] = state_value


#
# Returns the highest priority goal available.
#
func _get_best_goal() -> GoapGoal:
	var best_goal: GoapGoal = null
	var highest_priority: int = -1
	var valid_goals = _goals.filter(func(goal): return goal.is_valid())

	for goal: GoapGoal in valid_goals:
		var priority: int = goal.priority()
		if priority > highest_priority:
			highest_priority = priority
			best_goal = goal

	return best_goal


#
# Executes plan. This function is called on every game loop.
# "plan" is the current list of actions, and delta is the time since last loop.
#
# Every action exposes a function called perform, which will return true when
# the job is complete, so the agent can jump to the next action in the list.
#
func _follow_plan(plan: GoapPlan, delta: float) -> void:
	if plan.actions.is_empty():
		return

	var is_step_complete = plan.actions[_current_plan_step].perform(_actor, delta)
	if is_step_complete and _current_plan_step < plan.actions.size() - 1:
		_current_plan_step += 1
