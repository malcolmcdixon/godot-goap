extends RefCounted
class_name GoapPlan


var actions: Array[GoapAction]
var cost: float


# Constructor to initialize the plan with actions and cost
func _init(actions: Array = [], cost: float = 0.0) -> void:
	self.actions = actions
	self.cost = cost


# Add action to the plan and update cost
func add_action(action: GoapAction, action_cost: float) -> void:
	actions.append(action)
	cost += action_cost
