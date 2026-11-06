class_name StatusEffects
extends Node

var _effects: Array = []
var _remaining_times: Array = []

func add(effect: StatusEffect) -> void:
	_effects.append(effect)
	_remaining_times.append(effect.duration)

func tick(delta: float) -> void:
	var i := 0
	while i < _effects.size():
		var remaining := _remaining_times[i]
		var effect := _effects[i]
		var step := min(delta, remaining)
		effect.apply_tick(get_parent(), step)
		_remaining_times[i] = remaining - step
		if _remaining_times[i] == 0.0:
			_effects.remove_at(i)
			_remaining_times.remove_at(i)
		else:
			i += 1

func active_count() -> int:
	return _effects.size()

func speed_multiplier() -> float:
	var result := 1.0
	for effect in _effects:
		if effect is Slow:
			result *= effect.multiplier
	return result

func _physics_process(delta: float) -> void:
	tick(delta)