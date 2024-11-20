extends StaticBody2D
class_name TreeToChop


@onready var chop_cooldown: Timer = %chop_cooldown

var _hp = 3


func chop() -> bool:
	if not chop_cooldown.is_stopped():
		return false

	_hp -= 1
	if _hp == 0:
		queue_free()
		return true
	chop_cooldown.start()
	return false
