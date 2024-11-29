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


signal hunger_updated(hunger: int)

@onready var body: AnimatedSprite2D = %body
@onready var labels_container: VBoxContainer = %labels
@onready var detection_radius: Area2D = %detection_radius
@onready var hunger_timer: Timer = %HungerTimer

var _labels: Array[Label] = []
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
		KeepWoodStockedGoal.new(),
		],
		[
			GoapState.new(Goap.States.HAS_WOOD, false),
			GoapState.new(Goap.States.IS_STOCKPILING, false),
			GoapState.new(Goap.States.HAS_FIREPIT, false),
			GoapState.new(Goap.States.IS_HUNGRY, false),
			GoapState.new(Goap.States.HUNGER, 0),
			GoapState.new(Goap.States.PROTECTED, false),
		]
	)
	
	add_child(agent)
	
	# Get state indicator labels
	for label in labels_container.get_children():
		_labels.append(label)

	# connect to signals
	detection_radius.body_entered.connect(_on_detection_radius_body_entered)
	hunger_timer.timeout.connect(_on_hunger_timer_timeout)


func _process(_delta: float) -> void:
	_labels[0].visible = Goap.world_state.get_or_default(Goap.States.HUNGER, 0) >= 50
	_labels[1].visible = Goap.world_state.get_or_default(Goap.States.IS_FRIGHTENED, false)

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


func _on_detection_radius_body_entered(detected: Node2D) -> void:
	if detected.is_in_group("troll"):
		Goap.world_state.is_frightened = true


func _on_hunger_timer_timeout() -> void:
	var hunger = Goap.world_state.hunger
	if hunger < 100:
		hunger += 2
		hunger_updated.emit(hunger)
		if hunger > 50:
			Goap.world_state.is_hungry = true
		
		Goap.world_state.hunger = hunger
