class_name TimerActionStrategy
extends ActionStrategy


var _duration: float:
	set(value):
		_duration = max(value, 0.0)

var elapsed_time: float = 0.0


func _init(duration: float) -> void:
	_duration = duration

func _start(_actor: Node) -> bool:
	elapsed_time = 0.0
	return true


func _execute(_actor: Node, delta: float) -> bool:
	elapsed_time += delta
	if elapsed_time >= _duration:
		return true
	
	return false
