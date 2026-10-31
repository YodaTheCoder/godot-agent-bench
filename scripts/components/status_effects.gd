class_name StatusEffects
extends Node
## Holds the status effects active on the parent node and ticks them.

var _effects: Array[StatusEffect] = []
var _remaining: Array[float] = []


func _physics_process(delta: float) -> void:
	tick(delta)


func add(effect: StatusEffect) -> void:
	_effects.append(effect)
	_remaining.append(effect.duration)


## Advances every effect by `delta` seconds (at most its remaining time) and removes
## the ones that have run for their whole duration.
func tick(delta: float) -> void:
	var target := get_parent()
	for i in range(_effects.size() - 1, -1, -1):
		var step := minf(delta, _remaining[i])
		_effects[i].apply_tick(target, step)
		_remaining[i] -= step
		if _remaining[i] <= 0.0:
			_effects.remove_at(i)
			_remaining.remove_at(i)


func active_count() -> int:
	return _effects.size()


## Product of the multipliers of all active Slow effects (1.0 when there are none).
func speed_multiplier() -> float:
	var result := 1.0
	for effect in _effects:
		if effect is Slow:
			result *= (effect as Slow).multiplier
	return result
