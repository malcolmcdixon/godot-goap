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

var _action_planner: GoapActionPlanner =  GoapActionPlanner.new()

# world state #
var _state: Dictionary = {}

var state: Dictionary:
	get:
		return _state


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


func get_state(state_name, default = null) -> Variant:
	return _state.get(state_name, default)


func set_state(state_name, value) -> void:
	_state[state_name] = value


func clear_state() -> void:
	_state = {}
