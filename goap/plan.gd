extends RefCounted
class_name GoapPlan

static var NO_PLAN: GoapPlan

var steps: Array[GoapStep] = []
var cost: int


static func _static_init() -> void:
	NO_PLAN = GoapPlan.new()


# Constructor to initialize the plan with actions and cost
func _init(plan_steps: Array[GoapStep] = []) -> void:
	self.steps = plan_steps


# Add step to the plan
func add_step(
	action: GoapAction, \
	action_cost: int,
	desired_state: Array[GoapState], \
	blackboard: Array[GoapState]
) -> void:
	var step: GoapStep = GoapStep.new(action, action_cost, desired_state, blackboard)
	steps.push_front(step)
	self.cost += action_cost


# Add an array of steps to the plan
func add_steps(new_steps: Array[GoapStep]) -> void:
	self.steps.append_array(new_steps)
	_update_plan_cost()


# Duplicate method
func duplicate(deep: bool = false) -> GoapPlan:
	var plan: GoapPlan = GoapPlan.new()
	for step: GoapStep in self.steps:
		plan.steps.append(step.duplicate(deep))
	return plan


# Check if the given action is in the plan
func has_action(action: GoapAction) -> bool:
	return not steps.filter( \
		func(step: GoapStep): return step.action == action).is_empty()


# Recalculate cost of plan, primarily used for cached full / partial plans
func recalculate_cost(blackboard: Dictionary) -> int:
	for step: GoapStep in steps:
		step.cost = step.action.get_cost(blackboard)

	_update_plan_cost()
	
	return self.cost


func _update_plan_cost() -> void:
	self.cost = self.steps.reduce( \
		func(total: int, step: GoapStep): return total + step.cost, 0)
