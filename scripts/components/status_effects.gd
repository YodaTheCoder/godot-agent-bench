class_name StatusEffects
extends Node

var _effects: Array = []
var _times: Array = []

func add(effect: StatusEffect) -> void:
	_effects.append(effect)
	_times.append(0.0)

func tick(delta: float) -> void:
	var i := 0
	while i < _effects.size():
		var remaining := _effects[i].duration - _times[i]
		var step := min(delta, remaining)
		_effects[i].apply_tick(get_parent(), step)
		_times[i] += step
		if _times[i] >= _effects[i].duration:
			_effects.remove_at(i)
			_times.remove_at(i)
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