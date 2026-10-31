class_name Weapon
extends Node

## Shots per second.
@export var fire_rate := 4.0

var _last_shot_time := -INF


func try_fire(now: float) -> bool:
	if now - _last_shot_time < fire_rate:
		return false
	_last_shot_time = now
	return true
