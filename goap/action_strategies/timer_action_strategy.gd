extends ActionStrategy
class_name TimerActionStrategy


var _timer: SceneTreeTimer
var _duration: float:
	set(value):
		_duration = max(value, 0.0)

var elapsed_time: float = 0.0
var _condition: Callable


func _init(duration: float) -> void:
	_duration = duration

func _start(actor: Node) -> bool:
	elapsed_time = 0.0
	return true


func _execute(actor: Node, delta: float) -> bool:
	elapsed_time += delta
	if elapsed_time >= _duration:
		return true
	
	return false
