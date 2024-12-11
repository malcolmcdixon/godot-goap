#
# This script integrates the actor (NPC) with goap.
# In your implementation you could have this logic
# inside your NPC script.
#
# As good practice, I suggest leaving it isolated like
# this, so it makes re-use easy and it doesn't get tied
# to unrelated implementation details (movement, collisions, etc)
class_name GoapAgent
extends Node


var _goals: Array[GoapGoal]
var _current_goal: GoapGoal
var _current_plan: GoapPlan
var _current_plan_step: int = 0

var _actor: Node
var _agent_state: StateManager
var _sensors: Array[GoapSensor]


func init(actor: Node, goals: Array[GoapGoal]) -> void:
	_actor = actor
	_goals = goals

	get_tree().current_scene.child_entered_tree.connect(_on_child_entered_tree)


# Connect to Goap state change signal
#func _ready() -> void:
	#Goap.world_state.changed.connect(_on_state_changed)


#
# On every loop this script checks if the current goal is still
# the highest priority. if it's not, it requests the action planner a new plan
# for the new high priority goal.
#
func _process(delta: float) -> void:
	# Check if we need a new plan; otherwise, follow the current one.
	var goal: GoapGoal = _get_best_goal()
	if goal != _current_goal:
		_make_plan(goal)
	else:
		_follow_plan(_current_plan, delta)


func _on_child_entered_tree(node: Node) -> void:
	# Retrieve sensors not connected
	var sensors_not_connected: Array[GoapSensor] = \
		_sensors.filter(
			func(sensor: GoapSensor): return not sensor.connection.connected
		)

	for sensor: GoapSensor in sensors_not_connected:
		sensor.reconnect(node)


func add_sensor(sensor: GoapSensor) -> void:
	_sensors.append(sensor)


func _make_plan(goal: GoapGoal) -> void:
	_current_goal = goal
	
	# Goal specific states
	Goap.world_state.is_stockpiling = goal is KeepWoodStockedGoal
	
	# You can set in the blackboard any relevant information you want to use
	# when calculating action costs and status. I'm not sure here is the best
	# place to leave it, but I kept here to keep things simple.
	_agent_state = StateManager.new(Goap.world_state.get_states())
	_agent_state.position = _actor.position

	#var start_time: float = Time.get_ticks_usec()

	_current_plan = Goap.get_action_planner().get_plan(_current_goal, _agent_state)

	#prints("Time Elapsed for planning goal:", Time.get_ticks_usec() - start_time)

	_current_plan_step = 0


# Update the blackboard with the specific state change
#func _on_state_changed(state_key: StringName, state_value: Variant) -> void:
#func _on_state_changed(state: GoapState) -> void:
	#_agent_state.update(state)


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
	if plan == GoapPlan.NO_PLAN:
		return

	var action: GoapAction = plan.steps[_current_plan_step].action
		
	var is_step_complete: bool = action.perform(_actor, delta)

	if is_step_complete:
		# Apply action's effects to world state
		#action.apply_effects(Goap.world_state)
		Goap.world_state.apply_effects(action.effects)

		var last_step: int = plan.steps.size() - 1
		if _current_plan_step < last_step:
			_current_plan_step += 1
		# reset current plan step to zero for repeated goals
		elif _current_plan_step == last_step:
			_current_plan_step = 0
