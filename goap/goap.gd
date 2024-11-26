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
	POSITION
}

var _action_planner: GoapActionPlanner =  GoapActionPlanner.new()

# world state #
var world_state: StateManager = StateManager.new()


func _ready() -> void:
	_action_planner.set_actions([
		BuildFirepitAction.new(),
		ChopTreeAction.new(),
		CollectFromWoodStockAction.new(),
		CalmDownAction.new(),
		FindCoverAction.new(),
		FindFoodAction.new(),
	])


func get_action_planner() -> GoapActionPlanner:
	return _action_planner
