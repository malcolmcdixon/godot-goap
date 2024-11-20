# This NPC does not use GOAP.
# This is just a simple script which chooses
# a random position in the scene to move to.
extends CharacterBody2D


@onready var body: AnimatedSprite2D = %body
@onready var rest_timer: Timer = %rest_timer

var _target: Vector2


func _ready() -> void:
	_pick_random_position()
	body.play("run")
	
	# connect to signals
	rest_timer.timeout.connect(_on_rest_timer_timeout)


func _process(delta: float) -> void:
	if self.position.distance_to(_target) > 1 :
		var direction: Vector2 = self.position.direction_to(_target)
		if direction.x > 0:
			turn_right()
		else:
			turn_left()

	# warning-ignore:return_value_discarded
		move_and_collide(direction * delta * 100)
	else:
		body.play("idle")
		rest_timer.start()
		set_process(false)


func _pick_random_position() -> void:
	randomize()
	_target = Vector2(randi() % 445 + 5, randi() % 245 + 5)


func _on_rest_timer_timeout() -> void:
	_pick_random_position()
	body.play("run")
	set_process(true)


func turn_right() -> void:
	if not body.flip_h:
		return

	body.flip_h = false
	#$RayCast2D.target_position *= -1


func turn_left() -> void:
	if body.flip_h:
		return

	body.flip_h = true
	#$RayCast2D.target_position *= -1
