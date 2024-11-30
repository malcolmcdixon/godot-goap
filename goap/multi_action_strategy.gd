extends ActionStrategy
class_name MultiActionStrategy


var _strategies: Array[ActionStrategy] = []


func _init(strategies: Array[ActionStrategy]) -> void:
	_strategies = strategies

	# Set the shared context for all strategies at initialization
	for strategy in strategies:
		strategy.context = self.context


func execute(actor: Node, delta: float) -> bool:
	for strategy in _strategies:
		if not strategy.execute(actor, delta):
			return false
	
	return true
