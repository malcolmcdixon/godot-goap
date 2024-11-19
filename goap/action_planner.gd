#
# Planner. Goap's heart.
#
extends Node

class_name GoapActionPlanner

static var ROOT_ACTION = GoapAction.new()

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
func get_plan(goal: GoapGoal, blackboard: Dictionary = {}) -> Array:
	print("Goal: %s" % goal.get_clazz())
	WorldState.console_message("Goal: %s" % goal.get_clazz())
	var desired_state: Dictionary = goal.get_desired_state().duplicate()

	if desired_state.is_empty():
		return []

	return _find_best_plan(desired_state, blackboard)


func _find_best_plan(desired_state: Dictionary, blackboard: Dictionary	) -> Array:
	# using a GoapStep with the ROOT_ACTION action
 	# as the root node to keep the code simple
	var root: GoapStep = GoapStep.new(self.ROOT_ACTION, desired_state)

	# build plans will populate root with children.
	# In case it doesn't find a valid path, it will return false.
	if _build_plans(root, blackboard.duplicate()):
		var plans: Array = _transform_tree_into_array(root, blackboard)
		return _get_cheapest_plan(plans)

	return []


#
# Compares plan's cost and returns
# actions included in the cheapest one.
#
func _get_cheapest_plan(plans: Array) -> Array:
	if plans.is_empty():
		return []

	var best_plan: Dictionary = plans[0]
	for plan: Dictionary in plans:
		_print_plan(plan)
		if plan.cost < best_plan.cost:
			best_plan = plan

	return best_plan.actions


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
func _build_plans(step: GoapStep, blackboard: Dictionary) -> bool:
	var found_solution: bool = false

  # each node in the graph has it's own desired state.
	var step_state: Dictionary = step.state.duplicate()
  # checks if the blackboard contains data that can
  # satisfy the current state.
	for state in step.state:
		if step_state[state] == blackboard.get(state):
			step_state.erase(state)

  # if the state is empty, it means this branch already
  # found the solution, so it doesn't need to look for
  # more actions
	if step_state.is_empty():
		return true

	for action: GoapAction in _actions:
		if not action.is_valid():
			continue

		var should_use_action: bool = false
		var effects: Dictionary = action.get_effects()
		var desired_state: Dictionary = step_state.duplicate()

	# check if action should be used, i.e. it
	# satisfies at least one condition from the
	# desired state
		for state in desired_state:
			if desired_state[state] == effects.get(state):
				desired_state.erase(state)
				should_use_action = true

		if should_use_action:
			# adds actions pre-conditions to the desired state
			var preconditions: Dictionary = action.get_preconditions()
			for precondition in preconditions:
				desired_state[precondition] = preconditions[precondition]

			var next_step: GoapStep = GoapStep.new(action, desired_state)

			# if desired state is empty, it means this action
			# can be included in the graph.
			# if it's not empty, _build_plans is called again (recursively) so
			# it can try to find actions to satisfy this current state. In case
			# it can't find anything, this action won't be included in the graph.
			if not desired_state.is_empty():
				found_solution = _build_plans(next_step, blackboard.duplicate())
			else:
				found_solution = true
			
			if found_solution:
				step.add_next_step(next_step)

	return found_solution


#
# Transforms graph with actions into list of actions and calculates
# the cost by summing actions' cost
#
# Returns list of plans.
#
func _transform_tree_into_array(step: GoapStep, blackboard: Dictionary) -> Array:
	var plans: Array = []

	if step.next_steps.size() == 0:
		plans.push_back({ "actions": [step.action], "cost": step.action.get_cost(blackboard) })
		return plans

	for next_step in step.next_steps:
		for child_plan in _transform_tree_into_array(next_step, blackboard):
			# Skip the ROOT_ACTION to not include in the plan.
			if step.action != self.ROOT_ACTION:
				child_plan.actions.push_back(step.action)
				child_plan.cost += step.action.get_cost(blackboard)
			plans.push_back(child_plan)
	return plans


#
# Prints plan. Used for Debugging only.
#
func _print_plan(plan: Dictionary) -> void:
	var actions: Array[String] = []
	for a: GoapAction in plan.actions:
		actions.push_back(a.get_clazz())
	print({"cost": plan.cost, "actions": actions})
	WorldState.console_message({"cost": plan.cost, "actions": actions})
