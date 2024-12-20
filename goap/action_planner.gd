#
# Planner. Goap's heart.
#
class_name GoapActionPlanner
extends Node



const INT_INF: int = 9223372036854775807

var _actions: Array[GoapAction] = []
#var _memoized_plans: Dictionary = {}


#
# set actions available for planning.
# this can be changed in runtime for more dynamic options.
#
func _init(actions: Array[GoapAction] = [] ) -> void:
	_actions = actions
	
# Bulk replace all actions in the planner	
func set_actions(actions: Array[GoapAction]) -> void:
	_actions = actions


# Add a single action to the list
func add_action(action: GoapAction) -> void:
	if action not in _actions:
		_actions.append(action)


# Remove a single action from the list
func remove_action(action: GoapAction) -> void:
	_actions.erase(action)


#
# Receives a Goal and an optional blackboard.
# Returns a list of actions to be executed.
#
func get_plan(goal: GoapGoal, blackboard: StateManager) -> GoapPlan:
	if goal.desired_state == null:
		return GoapPlan.NO_PLAN

	var plans: Array[GoapPlan] = []
	
	var start_time: float = Time.get_ticks_usec()

	# Build plans for the desired state
	_build_plans(GoapPlan.new(), [goal.desired_state], blackboard, plans)

	prints("Time Elapsed for building plans only - goal:", goal.get_clazz(), Time.get_ticks_usec() - start_time)
	
	# If no valid plans return NO_PLAN
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
	desired_state: Array[GoapState], 
	blackboard: StateManager,
	plans: Array[GoapPlan],
	best_cost: int = INT_INF
) -> void:
	# Check if the plan for this state is already memoized
	#var cache_key: String = JSON.stringify(desired_state)
	#if _memoized_plans.has(cache_key):
		#print("FOUND CACHED PLANS...")
		#var cached_plans: Array = _memoized_plans[cache_key]
		#for cached_plan: GoapPlan in cached_plans:
			#_print_plan(cached_plan)
			#var valid_plan: bool = true
			#for step: GoapStep in cached_plan.steps:
				#var cached_blackboard: Dictionary = step.blackboard
				#if cached_blackboard:
					#valid_plan = \
						#_has_all_key_value_pairs(blackboard, cached_blackboard)
				#if not valid_plan:
					#break
			#if valid_plan:
				#var cost: int = cached_plan.recalculate_cost(blackboard)
				#prints("USING CACHED PLAN", "new cost:", cost)
				#plans.append(cached_plan)
		#
		#return


	# Filter actions that are valid and not already in the plan and
	# the cost does not make the plan too expensive and
	# with matching desired effects
	var relevant_actions: Array[GoapAction] = _actions.filter(
		func(action: GoapAction) -> bool:
			# Check if the action has already been added to the plan or is invalid
			if plan.has_action(action) or not action.is_valid():
				return false
			# Check if the action's cost is too high
			if plan.cost + action.get_cost(blackboard) >= best_cost:
				return false
			# Check if any of the action's effects match the desired state
			for effect in action.effects:
				for state in desired_state:
					if state.equals(effect):
						return true
			return false
	)
	
	# Iterate through all the relevant actions
	for action: GoapAction in relevant_actions:
		var updated_state: Array[GoapState] = desired_state.duplicate()
		
		# Remove effects matched states from the updated state
		var matched_effects: Array[GoapState] = \
			_filter_matching_states(updated_state, action.effects)
		
		#if not matching_effects_key_value_pairs:
		if matched_effects.is_empty():
			continue

		# Add preconditions to the updated state
		updated_state.append_array(action.preconditions)

		# Remove blackboard state from the updated state
		var matched_blackboard_states: Array[GoapState] = \
			_filter_matching_states(updated_state, blackboard.get_states())
		
		# Create a new plan with this action added
		var new_plan: GoapPlan = plan.duplicate()
		
		new_plan.add_step(
			action,
			action.get_cost(blackboard),
			updated_state.duplicate(),
			matched_blackboard_states
		)

		# If the updated state is empty, we have a valid plan
		if updated_state.is_empty():
			# Cache the plan irrespective of its cost
			#_memoize_plan(new_plan)
			
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

	return


#func _memoize_plan(plan: GoapPlan) -> void:
	## Save full plan
	#_cache_plan(plan)
	#
	## If more than one step save partial plans
	#var steps_count = plan.steps.size()
	#if steps_count == 1:
		#return
#
	#for index: int in range(steps_count -1, 0, -1):
		#var partial: GoapPlan = GoapPlan.new()
		#partial.add_steps(plan.steps.slice(0, index))
		#_cache_plan(partial)


#func _cache_plan(plan: GoapPlan) -> void:
		## Use desired state of the last step (goal desired state) as key
		#var key: String = JSON.stringify(plan.steps[-1].desired_state)
		#if not _memoized_plans.has(key):
			#_memoized_plans[key] = []
		## Store a deep copy of the plan for caching
		#_memoized_plans[key].append(plan.duplicate(true))


# Filter states in the reference that match within target and
# remove states from target
func _filter_matching_states( \
	target: Array[GoapState], reference: Array[GoapState]) -> Array[GoapState]:
	# Remove matched states from the target
	var matched: Array[GoapState] = []
	matched = target.filter(
		func(state: GoapState):
			for ref_state in reference:
				if state.equals(ref_state):
					return true
			return false
	)
	for state in matched:
		target.erase(state)
	
	return matched


#
# Prints plan. Used for Debugging.
#
func _print_plan(plan: GoapPlan) -> void:
	var actions: Array[String] = []
	for step: GoapStep in plan.steps:
		actions.push_back(step.action.get_clazz())
	print({"cost": plan.cost, "actions": actions})
	Debug.console_message({"cost": plan.cost, "actions": actions})
