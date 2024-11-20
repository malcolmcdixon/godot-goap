extends Node2D


@onready var _hunger_field: ProgressBar = %hunger
@onready var _pause_button: Button = %pause
@onready var _console_button: Button = %console


func _on_hanger_timer_timeout() -> void:
	_hunger_field.value = Goap.get_state("hunger", 0)
	if _hunger_field.value < 100:
		_hunger_field.value += 2

	Goap.set_state("hunger", _hunger_field.value)


func _on_reload_pressed() -> void:
	Goap.clear_state()
	# warning-ignore:return_value_discarded
	self.get_tree().reload_current_scene()


func _on_pause_pressed() -> void:
	get_tree().paused = not get_tree().paused
	_pause_button.text = (
		"Resume" if get_tree().paused else "Pause"
	)


func _on_console_pressed() -> void:
	var console: Control = get_tree().get_nodes_in_group("console")[0]
	console.visible = not console.visible
	_console_button.text = (
		"Hide Console" if console.visible else "Show Console"
	)
