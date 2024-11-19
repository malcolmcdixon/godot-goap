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
var _current_plan
var _current_plan_step: int = 0

var _actor: Node


#
# On every loop this script checks if the current goal is still
# the highest priority. if it's not, it requests the action planner a new plan
# for the new high priority goal.
#
func _process(delta) -> void:
	
	var goal: GoapGoal = _get_best_goal()
	if _current_goal == null or goal != _current_goal:
		var start_time: float = Time.get_ticks_usec()
	# You can set in the blackboard any relevant information you want to use
	# when calculating action costs and status. I'm not sure here is the best
	# place to leave it, but I kept here to keep things simple.
		var blackboard: Dictionary = {
			"position": _actor.position,
			}

		for s in WorldState._state:
			blackboard[s] = WorldState._state[s]

		_current_goal = goal
		_current_plan = Goap.get_action_planner().get_plan(_current_goal, blackboard)
		_current_plan_step = 0
		prints("Time Elapsed for planning goal:", Time.get_ticks_usec() - start_time)
	else:
		_follow_plan(_current_plan, delta)

	

func init(actor: Node, goals: Array[GoapGoal]) -> void:
	_actor = actor
	_goals = goals


#
# Returns the highest priority goal available.
#
func _get_best_goal() -> GoapGoal:
	var highest_priority: GoapGoal = null

	for goal in _goals:
		if goal.is_valid() and (highest_priority == null or goal.priority() > highest_priority.priority()):
			highest_priority = goal

	return highest_priority


#
# Executes plan. This function is called on every game loop.
# "plan" is the current list of actions, and delta is the time since last loop.
#
# Every action exposes a function called perform, which will return true when
# the job is complete, so the agent can jump to the next action in the list.
#
func _follow_plan(plan, delta) -> void:
	if plan.size() == 0:
		return

	var is_step_complete = plan[_current_plan_step].perform(_actor, delta)
	if is_step_complete and _current_plan_step < plan.size() - 1:
		_current_plan_step += 1
