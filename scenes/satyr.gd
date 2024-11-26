#
# This NPC uses GOAP as AI. This script handles
# Only NPC related stuff, like moving and animations.

# All AI related code is inside GoapAgent.
#
# This is optional, but I usually like to have my AI code
# separated from the "dumb" modules that handle the basic low
# level stuff, this allows me to use the same Agent in different
# nodes.
#
extends CharacterBody2D


@onready var body: AnimatedSprite2D = %body
@onready var calm_down_timer: Timer = %calm_down_timer
@onready var labels: VBoxContainer = %labels
@onready var detection_radius: Area2D = %detection_radius

var is_moving: bool = false
var is_attacking: bool = false

func _ready() -> void:
  # Here is where I define which goals are available for this
  # npc. In this implementation, goals priority are calculated
  # dynamically. Depending on your use case you might want to
  # have a way to define different goal priorities depending on
  # npc.
	var agent: GoapAgent = GoapAgent.new()
	agent.init(self, [
		KeepFirepitBurningGoal.new(),
		KeepFedGoal.new(),
		CalmDownGoal.new(),
		RelaxGoal.new(),
		KeepWoodStockedGoal.new()
		],
		[
			GoapState.new(Goap.States.HAS_WOOD, false),
			GoapState.new(Goap.States.IS_STOCKPILING, false)
		]
	)
	
	add_child(agent)

	# connect to signals
	calm_down_timer.timeout.connect(_on_calm_down_timer_timeout)
	detection_radius.body_entered.connect(_on_detection_radius_body_entered)


func _process(_delta: float) -> void:
	labels.get_child(0).visible = Goap.world_state.get_or_default(Goap.States.HUNGER, 0) >= 50
	labels.get_child(1).visible = Goap.world_state.get_or_default(Goap.States.IS_FRIGHTENED, false)

	if is_attacking:
		body.play("attack")
	elif is_moving:
		is_moving = false
	else:
		body.play("idle")



func move_to(direction: Vector2, delta: float) -> void:
	is_moving = true
	is_attacking = false
	body.play("run")
	if direction.x > 0:
		turn_right()
	else:
		turn_left()

  # warning-ignore:return_value_discarded
	move_and_collide(direction * delta * 100)



func turn_right() -> void:
	if not body.flip_h:
		return

	body.flip_h = false


func turn_left() -> void:
	if body.flip_h:
		return

	body.flip_h = true


func chop_tree(tree: TreeToChop) -> bool:
	var is_finished = tree.chop()
	is_attacking = not is_finished
	return is_finished


func calm_down() -> bool:
	if Goap.world_state.is_frightened == false:
		return true

	if calm_down_timer.is_stopped():
		calm_down_timer.start()

	return false


func _on_detection_radius_body_entered(detected: Node2D) -> void:
	if detected.is_in_group("troll"):
		Goap.world_state.is_frightened = true


func _on_calm_down_timer_timeout() -> void:
	Goap.world_state.is_frightened = false
	
