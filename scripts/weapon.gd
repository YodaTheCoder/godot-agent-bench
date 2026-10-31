class_name Weapon
extends Node

## Shots per second.
@export var fire_rate := 4.0

## Slack for float rounding, so a shot exactly one cooldown later is allowed
## even when the subtraction lands a hair under the interval.
const _COOLDOWN_EPSILON := 1e-9

var _last_shot_time := -INF


func try_fire(now: float) -> bool:
	var cooldown := 1.0 / fire_rate
	if now - _last_shot_time < cooldown - _COOLDOWN_EPSILON:
		return false
	_last_shot_time = now
	return true
