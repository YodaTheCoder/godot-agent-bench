class_name StatusEffects
extends Node

class EffectData:
	var effect: StatusEffect
	var remaining: float

var _effects: Array = []

func add(effect: StatusEffect) -> void:
	var data = EffectData.new()
	data.effect = effect
	data.remaining = effect.duration
	_effects.append(data)

func tick(delta: float) -> void:
	var to_remove: Array = []
	for i in range(_effects.size() - 1, -1, -1):
		var data = _effects[i]
		var step = min(delta, data.remaining)
		data.effect.apply_tick(get_parent(), step)
		data.remaining -= step
		if data.remaining <= 0.0:
			to_remove.append(data)
	for data in to_remove:
		_effects.erase(data)

func _physics_process(delta: float) -> void:
	tick(delta)

func active_count() -> int:
	return _effects.size()

func speed_multiplier() -> float:
	var result := 1.0
	for data in _effects:
		if data.effect is Slow:
			result *= data.effect.multiplier
	return result