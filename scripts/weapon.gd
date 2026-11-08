class_name Weapon
extends Node

## Shots per second.
@export var fire_rate := 4.0

var _last_shot_time := -INF


func try_fire(now: float) -> bool:
	var cooldown := 1.0 / fire_rate
	if now - _last_shot_time < cooldown:
		return false
	_last_shot_time = now
	return true


func reset() -> void:
	_last_shot_time = -INF
