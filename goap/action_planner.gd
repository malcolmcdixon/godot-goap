#
# Planner. Goap's heart.
#
extends Node

class_name GoapActionPlanner


const INT_INF: int = 9223372036854775807

var _actions: Array[GoapAction]


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

	# using a GoapStep with the ROOT_ACTION action as the root node
	#var root: GoapStep = GoapStep.new(GoapAction.ROOT, desired_state)

	# Build the plans from the root node
	# If no valid plan is found, return NO_PLAN early
	#if not _build_plans(root, blackboard.duplicate()):
		#return GoapPlan.NO_PLAN
	var plans: Array[GoapPlan] = \
		_build_plans_new(GoapPlan.new(), desired_state, blackboard.duplicate())
	
	if plans.is_empty():
		return GoapPlan.NO_PLAN
	
	# Transform the action graph into a list of plans
	#var plans: Array = _transform_tree_into_array(root, blackboard)

	# Sort plans in order of cost
	if plans.size() > 1:
		plans.sort_custom(func(a, b): return a.cost < b.cost)
	# Return the plan with the least cost
	#var best_plan: GoapPlan = plans[0]
	for plan: GoapPlan in plans:
		print("=================================================================")
		print("Returned Plans:")
		_print_plan(plan)
		print("=================================================================")
		#if plan.cost < best_plan.cost:
			#best_plan = plan
#
	#return best_plan
	return plans[0]


#
# Builds graph with actions. Only includes valid plans (plans
# that achieve the goal).
#
# Returns true if the path has a solution.
#
# This function uses recursion to build the graph. This is
# necessary because any new action included in the graph may
# add pre-conditions to the desired state that can be satisfied
# by previously considered actions, meaning, on every step we
# need to iterate from the beginning to find all solutions.
#
# Be aware that for simplicity, the current implementation is not protected from
# circular dependencies. This is easy to implement though.
#
#func _build_plans( \
	#step: GoapStep, \
	#blackboard: Dictionary, \
	#best_cost: int = INT_INF \
#) -> bool:
	#var found_solution: bool = false
#
 	## each node in the graph has it's own desired state.
	#var step_state: Dictionary = step.state.duplicate()
	#
	## checks if the blackboard contains data that can satisfy the current state.
	#for state in step.state:
		#if step_state[state] == blackboard.get(state):
			#step_state.erase(state)
#
	## if the state is empty, it means this branch already found the solution,
	## so it doesn't need to look for more actions
	#if step_state.is_empty():
		#return true
#
	#for action: GoapAction in _actions:
		#if not action.is_valid():
			#continue
#
		#var should_use_action: bool = false
		#var effects: Dictionary = action.get_effects()
		#var desired_state: Dictionary = step_state.duplicate()
#
		## check if the action satisfies at least one condition
		## from the desired state
		#for state in desired_state:
			#if desired_state[state] == effects.get(state):
				#desired_state.erase(state)
				#should_use_action = true
#
		## Skip to the next action if this one is not applicable.
		#if not should_use_action:
			#continue
		#
		## Add the action's preconditions to the desired state
		## and create the next step.
#
		#var preconditions: Dictionary = action.get_preconditions()
		#for precondition in preconditions:
			#desired_state[precondition] = preconditions[precondition]
#
		#var next_step: GoapStep = GoapStep.new(action, desired_state)
#
		## if desired state is empty, this action can be included in the graph.
		## if it's not empty, _build_plans is called again (recursively) so
		## it can try to find actions to satisfy the desired state.
		## If it can't find anything, this action won't be included in the graph.
		#if not desired_state.is_empty():
			#found_solution = _build_plans(next_step, blackboard.duplicate())
		#else:
			#found_solution = true
		#
		#if found_solution:
			#step.add_next_step(next_step)
#
	#return found_solution


#
# Transforms graph with actions into list of actions and calculates
# the cost by summing actions' cost
#
# Returns list of plans.
#
#func _transform_tree_into_array(step: GoapStep, blackboard: Dictionary) -> Array[GoapPlan]:
	#var plans: Array[GoapPlan] = []
#
	#if step.next_steps.size() == 0:
		#plans.push_back( \
			#GoapPlan.new([step.action], \
			#step.action.get_cost(blackboard) \
			#) \
		#)
		#return plans
#
	#for next_step in step.next_steps:
		#for child_plan: GoapPlan in _transform_tree_into_array(next_step, blackboard):
			## Skip the ROOT_ACTION to not include in the plan.
			#if step.action != GoapAction.ROOT:
				#child_plan.add_action( \
					#step.action, step.action.get_cost(blackboard) \
				#)
			#plans.push_back(child_plan)
	#return plans


func _build_plans_new(
	plan: GoapPlan, 
	desired_state: Dictionary, 
	blackboard: Dictionary, 
	best_cost: int = INT_INF
) -> Array[GoapPlan]:
	var plans: Array[GoapPlan] = []

	# Prune this branch if the plan's cost exceeds the best cost so far
	if plan.cost >= best_cost:
		print("=================================================================")
		print("Pruning plan:")
		_print_plan(plan)
		print("=================================================================")
		return plans

	# If desired state is empty, we have a valid plan
	if desired_state.is_empty():
		plans.append(plan)
		return plans

	# Iterate through available actions
	for action: GoapAction in _actions:
		if not action.is_valid():
			continue

		var effects: Dictionary = action.get_effects()
		var updated_state: Dictionary = desired_state.duplicate()
		#prints("Updated State:", updated_state, "Blackboard:", blackboard)
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
		if plan.cost + action.get_cost(blackboard) >= best_cost:
			print("=================================================================")
			print("Pruning plan:")
			_print_plan(plan)
			prints("Expensive Action:", action.get_clazz(), action.get_cost(blackboard))
			print("=================================================================")
			continue

		# Add preconditions to the updated state
		var preconditions: Dictionary = action.get_preconditions()
		for precondition in preconditions:
			updated_state[precondition] = preconditions[precondition]

		# Create a new plan with this action added
		var new_plan: GoapPlan = plan.duplicate()
		new_plan.add_action(action, action.get_cost(blackboard))

		# Recursively build plans from the new state
		var child_plans: Array[GoapPlan] = _build_plans_new(new_plan, updated_state, blackboard, best_cost)
		for child_plan in child_plans:
			plans.append(child_plan)

			# Update best_cost if a better plan is found
			if child_plan.cost < best_cost:
				best_cost = child_plan.cost

	return plans


#
# Prints plan. Used for Debugging only.
#
func _print_plan(plan: GoapPlan) -> void:
	var actions: Array[String] = []
	for action: GoapAction in plan.actions:
		actions.push_back(action.get_clazz())
	print({"cost": plan.cost, "actions": actions})
	SceneManager.console_message({"cost": plan.cost, "actions": actions})
