class_name StatusEffects
extends Node

## Tolerance for deciding an effect has used up its duration despite float drift.
const EPSILON := 1e-9

# Active effects and the time each has been ticked so far, kept in matching order.
var _effects: Array[StatusEffect] = []
var _elapsed: Array[float] = []


func _physics_process(delta: float) -> void:
	tick(delta)


## Activates `effect` on the parent node for `effect.duration` seconds.
func add(effect: StatusEffect) -> void:
	_effects.append(effect)
	_elapsed.append(0.0)


## Advances every active effect by `delta` seconds, removing those that have expired.
func tick(delta: float) -> void:
	var target := get_parent()
	var expired: Array[int] = []
	for i in _effects.size():
		var remaining := _effects[i].duration - _elapsed[i]
		var step := clampf(delta, 0.0, maxf(remaining, 0.0))
		if step > 0.0:
			_effects[i].apply_tick(target, step)
		_elapsed[i] += step
		if remaining - step <= EPSILON:
			expired.append(i)
	expired.reverse()
	for i in expired:
		_effects.remove_at(i)
		_elapsed.remove_at(i)


func active_count() -> int:
	return _effects.size()


## Product of the multipliers of all active Slow effects; 1.0 when there are none.
func speed_multiplier() -> float:
	var result := 1.0
	for effect in _effects:
		var slow := effect as Slow
		if slow != null:
			result *= slow.multiplier
	return result
