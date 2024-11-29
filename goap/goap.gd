# This class is an Autoload accessible globaly.
# It initialises a GoapActionPlanner with the available
# actions.
#
# In your game, you might want to have different planners
# for different enemy/npc types, and even change the set
# of actions in runtime.
#
# This example keeps things simple, creating only one planner
# with pre-defined actions.
#
# world state is also stored here for the GOAP system
#
extends Node


# States allowed in this GOAP system, mainly used by StateManager and GoapState
enum States {
	HAS_FIREPIT,
	IS_HUNGRY,
	HUNGER,
	IS_FRIGHTENED,
	HAS_WOOD,
	PROTECTED,
	POSITION,
	IS_STOCKPILING,
}

var _action_planner: GoapActionPlanner =  GoapActionPlanner.new()

# world state #
var world_state: StateManager = StateManager.new(
	[
		GoapState.new(Goap.States.HAS_FIREPIT, false),
		GoapState.new(Goap.States.HAS_WOOD, false),
		GoapState.new(Goap.States.IS_STOCKPILING, false),
		GoapState.new(Goap.States.IS_HUNGRY, false),
		GoapState.new(Goap.States.HUNGER, 0),
		GoapState.new(Goap.States.PROTECTED, false),
	]
)


func _ready() -> void:
	_action_planner.set_actions([
		BuildFirepitAction.new("firepit_spot", 20.0),
		ChopTreeAction.new(),
		CollectFromWoodStockAction.new("wood_stock", 10.0),
		CalmDownAction.new(5.0),
		FindCoverAction.new(),
		FindFoodAction.new(),
		AddToWoodStockAction.new("wood_stock_spot", 10.0),
	])


func get_action_planner() -> GoapActionPlanner:
	return _action_planner
