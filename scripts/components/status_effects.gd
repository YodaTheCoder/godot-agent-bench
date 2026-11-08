class_name StatusEffects extends Node

var _effects: Array = []
var _remaining_times: Array = []
var _ticked_times: Array = []

func add(effect: StatusEffect) -> void:
	_effects.append(effect)
	_remaining_times.append(effect.duration)
	_ticked_times.append(0.0)

func tick(delta: float) -> void:
	var to_remove: Array = []
	for i in range(_effects.size() - 1, -1, -1):
		if _remaining_times[i] <= 0:
			continue
		var step := min(delta, _remaining_times[i])
		var effect := _effects[i] as StatusEffect
		effect.apply_tick(get_parent(), step)
		_remaining_times[i] -= step
		_ticked_times[i] += step
		if _ticked_times[i] >= effect.duration:
			to_remove.append(i)
	for i in to_remove:
		_effects.remove_at(i)
		_remaining_times.remove_at(i)
		_ticked_times.remove_at(i)

func active_count() -> int:
	return _effects.size()

func speed_multiplier() -> float:
	var result := 1.0
	for effect in _effects:
		if effect is Slow:
			result *= (effect as Slow).multiplier
	return result

func _physics_process(delta: float) -> void:
	tick(delta)