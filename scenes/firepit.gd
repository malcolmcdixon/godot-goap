class_name Firepit
extends Node2D


@onready var label: Label = %label
@onready var timer: Timer = %timer


signal burn_time_changed(time_left: float)

var _time_left: float
var elapsed_time: float = 0.0


func _ready() -> void:
	# connect to signals
	timer.timeout.connect(
		func(): 
			queue_free()
			Goap.world_state.has_firepit = false
	)


func _process(delta: float) -> void:
	_time_left = ceil(timer.time_left)
	label.text = str(_time_left)
	
	elapsed_time += delta
	if elapsed_time > 1.0:
		elapsed_time -= 1.0
		burn_time_changed.emit(_time_left)
