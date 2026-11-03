class_name Weapon
extends Node

## Shots per second.
@export var fire_rate := 4.0

var _last_shot_time := -INF


func try_fire(now: float) -> bool:
	if fire_rate > 0 and now - _last_shot_time < (1.0 / fire_rate):
		return false
	_last_shot_time = now
	return true
