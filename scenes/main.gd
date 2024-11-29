extends Node2D


@onready var _hunger_field: ProgressBar = %hunger
@onready var _pause_button: Button = %pause
@onready var _console_button: Button = %console
@onready var console_container: MarginContainer = %console_container
@onready var satyr: CharacterBody2D = %satyr


func _ready() -> void:
	# set debug console
	Debug.set_console_container(console_container, _console_button)
	
	# Connect to signals
	satyr.hunger_updated.connect(func(hunger): _hunger_field.value = hunger)


func _on_reload_pressed() -> void:
	Goap.state.clear()
	# warning-ignore:return_value_discarded
	self.get_tree().reload_current_scene()


func _on_pause_pressed() -> void:
	get_tree().paused = not get_tree().paused
	_pause_button.text = (
		"Resume" if get_tree().paused else "Pause"
	)
