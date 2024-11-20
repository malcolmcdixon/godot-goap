extends RefCounted
class_name GoapPlan

static var NO_PLAN: GoapPlan

var actions: Array[GoapAction]
var cost: float


static func _static_init() -> void:
	NO_PLAN = GoapPlan.new()


# Constructor to initialize the plan with actions and cost
func _init(plan_actions: Array[GoapAction] = [], plan_cost: float = 0.0) -> void:
	self.actions = plan_actions
	self.cost = plan_cost


# Add action to the plan and update cost
func add_action(action: GoapAction, action_cost: float) -> void:
	actions.append(action)
	cost += action_cost
