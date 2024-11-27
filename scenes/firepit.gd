extends Node2D


@onready var label: Label = %label
@onready var timer: Timer = %timer


func _ready() -> void:
	# connect to signals
	timer.timeout.connect(
		func(): 
			queue_free()
			Goap.world_state.has_firepit = false
	)


func _process(_delta):
	label.text = str(ceil(timer.time_left))
