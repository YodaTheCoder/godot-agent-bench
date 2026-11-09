class_name StatusEffects
extends Node

var _effects: Array = []
var _remaining: Array = []

func _physics_process(delta: float) -> void:
	tick(delta)

func add(effect: StatusEffect) -> void:
	_effects.append(effect)
	_remaining.append(effect.duration)

func tick(delta: float) -> void:
	for i in range(_effects.size() - 1, -1, -1):
		var step = min(delta, _remaining[i])
		_effects[i].apply_tick(get_parent(), step)
		_remaining[i] -= step
		if _remaining[i] <= 0.0:
			_effects.remove_at(i)
			_remaining.remove_at(i)

func active_count() -> int:
	return _effects.size()

func speed_multiplier() -> float:
	var result := 1.0
	for effect in _effects:
		if effect is Slow:
			result *= effect.multiplier
	return result