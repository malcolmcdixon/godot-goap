class_name ValueGoapCondition
extends GoapCondition


enum {
	EQUALS,
	NOT_EQUALS,
	LESS_THAN,
	LESS_THAN_OR_EQUAL,
	GREATER_THAN,
	GREATER_THAN_OR_EQUAL
}

@export var target_value: float
@export var operand: int = EQUALS


func _init(init_name: StringName, value: float, init_operand: int) -> void:
	super._init(init_name)
	target_value = value
	operand = init_operand


func evaluate(args: Variant) -> bool:
	if not (args is int or args is float):
		push_warning("AreaGoapSensor._on_signal_triggered: \
			Passed argument is not an int or float")
		return false
	
	var value
	
	match typeof(args):
		TYPE_INT:
			value = args as int
		TYPE_FLOAT:
			value = args as float

	match operand:
		EQUALS: return value == target_value
		NOT_EQUALS: return value != target_value
		LESS_THAN: return value < target_value
		LESS_THAN_OR_EQUAL: return value <= target_value
		GREATER_THAN: return value > target_value
		GREATER_THAN_OR_EQUAL: return value >= target_value
		_:
			push_warning("ValueGoapCondition.evaluate: Invalid operand")
			return false
