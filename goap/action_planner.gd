#
# Planner. Goap's heart.
#
extends Node

class_name GoapActionPlanner


const INT_INF: int = 9223372036854775807

var _actions: Array[GoapAction] = []
var _plans: Array[GoapPlan] = []

#
# set actions available for planning.
# this can be changed in runtime for more dynamic options.
#
func set_actions(actions: Array[GoapAction]) -> void:
	_actions = actions


#
# Receives a Goal and an optional blackboard.
# Returns a list of actions to be executed.
#
func get_plan(goal: GoapGoal, blackboard: Dictionary = {}) -> GoapPlan:
	# Debugging output: show the goal
	print("Goal: %s" % goal.get_clazz())

	SceneManager.console_message("Goal: %s" % goal.get_clazz())

	var desired_state: Dictionary = goal.get_desired_state().duplicate()

	if desired_state.is_empty():
		return GoapPlan.NO_PLAN

	# Clear any previous plans
	_plans.clear()
	# Build plans for the desired state
	_build_plans(GoapPlan.new(), desired_state, blackboard.duplicate())
	
	# If no valid plans return NO_PLAN early
	if _plans.is_empty():
		return GoapPlan.NO_PLAN
	
	# Sort plans in order of cost if more than one returned
	if _plans.size() > 1:
		_plans.sort_custom(func(a, b): return a.cost < b.cost)
#
	# Return best_plan
	return _plans[0]


#
# Builds plans with actions. Only includes valid plans (plans
# that achieve the goal).
#
# This function uses recursion to build the plans. This is
# necessary because any new action included in the plan may
# add pre-conditions to the desired state that can be satisfied
# by previously considered actions, meaning, on every step we
# need to iterate from the beginning to find all solutions.
#
# Be aware that for simplicity, the current implementation is not protected from
# circular dependencies. This is easy to implement though.
#
func _build_plans(
	plan: GoapPlan, 
	desired_state: Dictionary, 
	blackboard: Dictionary, 
	best_cost: int = INT_INF
) -> void:
	# Iterate through available actions
	for action: GoapAction in _actions:
		# Check if the action has already been added to the plan
		if plan.actions.has(action):
			continue 

		if not action.is_valid():
			continue

		var effects: Dictionary = action.get_effects()
		var updated_state: Dictionary = desired_state.duplicate()
		var action_used: bool = false

		
		# Check if this action satisfies any condition
		for key in desired_state:
			if updated_state[key] == effects.get(key):
				updated_state.erase(key)
				action_used = true

		# Skip this action if it doesn't satisfy any condition
		if not action_used:
			continue

		# Skip this action as it leads to an expensive plan
		var action_cost: int = action.get_cost(blackboard)
		if plan.cost + action_cost >= best_cost:
			#print("=================================================================")
			#print("Pruning plan:")
			#_print_plan(plan)
			#prints("Expensive Action:", action.get_clazz(), action.get_cost(blackboard))
			#print("=================================================================")
			continue

		# Add preconditions to the updated state
		var preconditions: Dictionary = action.get_preconditions()
		for precondition in preconditions:
			updated_state[precondition] = preconditions[precondition]

		# Create a new plan with this action added
		var new_plan: GoapPlan = plan.duplicate()
		new_plan.add_action(action, action_cost)

		# If the updated state is empty, we have a valid plan
		if updated_state.is_empty():
			_plans.append(new_plan)
			best_cost = min(new_plan.cost, best_cost)
		else:	
			# Recursively build plans from the new plan and state
			_build_plans(new_plan, updated_state, blackboard, best_cost)

	return


#
# Prints plan. Used for Debugging only.
#
func _print_plan(plan: GoapPlan) -> void:
	var actions: Array[String] = []
	for action: GoapAction in plan.actions:
		actions.push_back(action.get_clazz())
	print({"cost": plan.cost, "actions": actions})
	SceneManager.console_message({"cost": plan.cost, "actions": actions})
