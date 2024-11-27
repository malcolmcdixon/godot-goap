extends Node


var _console_container: Control
var _console: Control
var _console_button: Button


func set_console_container(console: Control, console_button: Button) -> void:
	_console_container = console
	_console = console.get_child(0)
	_console_button = console_button
	_console_button.pressed.connect(_on_console_pressed)


func console_message(object) -> void:
	if _console:
		_console.text += "\n%s" % str(object)
		_console.set_caret_line(_console.get_line_count())


func _on_console_pressed() -> void:
	_console_container.visible = not _console_container.visible
	_console_button.text = (
		"Hide Console" if _console_container.visible else "Show Console"
	)
