extends ActionStrategy
class_name MultiActionStrategy


var strategies: Array[ActionStrategy] = []


func execute(actor: Node, delta: float) -> bool:
	for strategy in strategies:
		if not strategy.execute(actor, delta):
			return false
	
	return true
