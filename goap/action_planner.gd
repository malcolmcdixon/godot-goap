#
# Planner. Goap's heart.
#
extends Node

class_name GoapActionPlanner


const INT_INF: int = 9223372036854775807

var _actions: Array[GoapAction] = []


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

	var plans: Array[GoapPlan] = []
	# Build plans for the desired state
	_build_plans(GoapPlan.new(), desired_state, blackboard.duplicate(), plans)
	
	# If no valid plans return NO_PLAN early
	if plans.is_empty():
		return GoapPlan.NO_PLAN
	
	# Return best_plan, which is the last one in the array
	return plans[-1]


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
	plans: Array[GoapPlan],
	best_cost: int = INT_INF
) -> void:
	
	# Filter actions for actions with desired effects
	var relevant_actions: Array[GoapAction] = _actions.filter(
		func(action: GoapAction):
			# Check if the action has already been added to the plan or is invalid
			if plan.actions.has(action) or \
				not action.is_valid() or \
				plan.cost + action.get_cost(blackboard) >= best_cost:
					return false
			var effects: Dictionary = action.get_effects()
			return effects.keys().any( \
				func(key): return desired_state.get(key) == effects[key])
	)
	
	# Iterate through all the relevant actions
	for action: GoapAction in relevant_actions:
		var effects: Dictionary = action.get_effects()
		var updated_state: Dictionary = desired_state.duplicate()
		
		# Remove effects matched key/value pairs from the updated state
		_filter_matching_key_value_pairs(updated_state, effects)

		# Add preconditions to the updated state
		updated_state.merge(action.get_preconditions(), true)

		# Remove blackboard matched key/value pairs from the updated state
		_filter_matching_key_value_pairs(updated_state, blackboard)
		
		# Create a new plan with this action added
		var new_plan: GoapPlan = plan.duplicate()
		new_plan.add_action(action, action.get_cost(blackboard))

		# If the updated state is empty, we have a valid plan
		if updated_state.is_empty():
			# Ensure the new plan's cost is less than the best before adding it
			# Therefore, the last plan in the array will be the best
			if new_plan.cost < best_cost:
				plans.append(new_plan)
				best_cost = new_plan.cost
		else:	
			# Recursively build plans from the new plan and state
			_build_plans(new_plan, updated_state, blackboard, plans, best_cost)

		# Release variables
		relevant_actions.clear()
		effects.clear()
		updated_state.clear()
		new_plan = null

	return


# Filter keys in the reference that match values with target and
# remove key / value pairs from target
func _filter_matching_key_value_pairs( \
	target: Dictionary, reference: Dictionary) -> void:
	var relevant_keys = reference.keys().filter( \
	func(key): return target.get(key) == reference[key])
	
	# Remove matched keys from the target state
	for key in relevant_keys:
		target.erase(key)


#
# Prints plan. Used for Debugging only.
#
func _print_plan(plan: GoapPlan) -> void:
	var actions: Array[String] = []
	for action: GoapAction in plan.actions:
		actions.push_back(action.get_clazz())
	print({"cost": plan.cost, "actions": actions})
	SceneManager.console_message({"cost": plan.cost, "actions": actions})
