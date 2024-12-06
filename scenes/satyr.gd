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


@export var agent: GoapAgent
@onready var body: AnimatedSprite2D = %body
@onready var labels_container: VBoxContainer = %labels
@onready var detection_radius: Area2D = %detection_radius
@onready var close_proxity_detector: Area2D = %close_proxity_detector
@onready var hunger_timer: Timer = %HungerTimer
@onready var rotation_anchor: Node2D = %RotationAnchor


var _labels: Array[Label] = []
var is_moving: bool = false
var is_attacking: bool = false


func _ready() -> void:
  # Here is where I define which goals are available for this
  # npc. In this implementation, goals priority are calculated
  # dynamically. Depending on your use case you might want to
  # have a way to define different goal priorities depending on
  # npc.
	agent.init(
		self,
		[
			KeepFirepitBurningGoal.new(),
			KeepFedGoal.new(),
			CalmDownGoal.new(),
			RelaxGoal.new(),
			KeepWoodStockedGoal.new(),
			PrepareWoodGoal.new(),
			AvoidEnemyGoal.new(),
		]
	)
	
	# Add sensors used by the agent
	#
	# Sensor to detect when close to another Area2D
	#
	var sensor = NodeGoapSensor.new(
		agent,
		SignalConnection.new(
			"body_entered",
			detection_radius
			),
	)
	
	var condition: GoapCondition = IsTypeGoapCondition.new(
		"IsTroll", "Troll"
	)

	# Rule to check if Troll and set state to is frightened
	var rule: GoapRule = GoapRule.new(
		"Troll Nearby",
		condition,
		[GoapState.new(Goap.States.IS_FRIGHTENED, true)]
	)
	
	sensor.add_rule(rule)
	
	#
	# rule to check if Mushroom and set state to near food
	#
	condition = IsTypeGoapCondition.new(
		"IsFood", "Mushroom"
	)
	
	rule = GoapRule.new(
		"Food Nearby",
		condition,
		[GoapState.new(Goap.States.NEAR_FOOD, true)]
	)
	
	sensor.add_rule(rule)
	
	agent.add_sensor(sensor)

	#
	# Sensor to detect when leaving the detection_radius
	#
	sensor = NodeGoapSensor.new(
		agent,
		SignalConnection.new(
			"body_exited",
			detection_radius
			),
	)
	
	#
	# Uses IsFood condition and set state to not near food
	#
	rule = GoapRule.new(
		"No Food Nearby",
		condition,
		[GoapState.new(Goap.States.NEAR_FOOD, false)]
	)
	
	sensor.add_rule(rule)
	
	condition = IsTypeGoapCondition.new(
		"IsTroll", "Troll"
	)

	# Rule to check if Troll and set state to no nearby enemy
	rule = GoapRule.new(
		"No Troll Nearby",
		condition,
		[GoapState.new(Goap.States.NEAR_ENEMY, false)]
	)
	
	sensor.add_rule(rule)
	
	agent.add_sensor(sensor)
	
	#
	# Sensor to check values on the Firepit countdown
	#
	sensor = ValueGoapSensor.new(
		agent,
		SignalConnection.new(
			"burn_time_changed",
			null,
			func(node): return node is Firepit
		),
	)
		
	condition = ValueGoapCondition.new(
		"LessThan3", 3, ValueGoapCondition.LESS_THAN_OR_EQUAL
	)
	
	#
	# Rule to check if less than 3 seconds left
	# and set state to prepare wood
	#
	rule = GoapRule.new(
		"Firepit Burn Time Low",
		condition,
		[GoapState.new(Goap.States.PREPARE_WOOD, true)]
	)
	
	sensor.add_rule(rule)
	
	agent.add_sensor(sensor)
	
	#
	# Sensor to detect when entering the close proximity Area2D
	#
	sensor = NodeGoapSensor.new(
		agent,
		SignalConnection.new(
			"body_entered",
			close_proxity_detector
			),
	)
	
	condition = IsTypeGoapCondition.new(
		"IsTroll", "Troll"
	)

	# Rule to check if Troll and set state to nearby enemy
	rule = GoapRule.new(
		"Troll in Close Proximity",
		condition,
		[GoapState.new(Goap.States.NEAR_ENEMY, true)]
	)
	
	sensor.add_rule(rule)
	
	agent.add_sensor(sensor)
	
	#
	# Sensor to detect when leaving the close proximity Area2D
	#
	sensor = NodeGoapSensor.new(
		agent,
		SignalConnection.new(
			"body_exited",
			close_proxity_detector
			),
	)
	
	condition = IsTypeGoapCondition.new(
		"IsFirepit", "Firepit"
	)
	
	#
	# Rule to check if Firepit and set state to not at firepit
	#
	rule = GoapRule.new(
		"Not At Firepit",
		condition,
		[GoapState.new(Goap.States.AT_FIREPIT, false)]
	)
	
	sensor.add_rule(rule)
	
	agent.add_sensor(sensor)
	
	# Get state indicator labels
	for label in labels_container.get_children():
		_labels.append(label)

	# connect to signals
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
	body.flip_h = direction.x < 0

	# warning-ignore:return_value_discarded
	move_and_collide(direction * delta * 100)


func chop_tree(tree: TreeToChop) -> bool:
	var is_finished = tree.chop()
	is_attacking = not is_finished
	return is_finished


func _on_hunger_timer_timeout() -> void:
	var hunger = Goap.world_state.hunger
	if hunger < 100:
		hunger += 2
		hunger_updated.emit(hunger)
		if hunger > 50:
			Goap.world_state.is_hungry = true
		
		Goap.world_state.hunger = hunger


func _on_close_proxity_detector_body_entered(detected: Node2D) -> void:
	# If there's a collision with the Troll move the bearing
	if not detected is Troll:
		return

	var vector: Vector2 = global_position - body.global_position
	rotation_anchor.rotation = fmod(vector.angle(), 2 * PI)
