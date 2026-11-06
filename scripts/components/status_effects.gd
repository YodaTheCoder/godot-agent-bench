class_name StatusEffects
extends Node

var _effects := []

func add(effect: StatusEffect) -> void:
	_effects.append({
		"effect": effect,
		"remaining": effect.duration
	})

func _physics_process(delta: float) -> void:
	tick(delta)

func tick(delta: float) -> void:
	var to_remove := []
	for i in range(_effects.size()):
		var effect_data = _effects[i]
		var effect = effect_data.effect as StatusEffect
		if effect == null:
			continue
		var remaining = effect_data.remaining as float
		var step = min(delta, remaining)
		effect.apply_tick(get_parent(), step)
		effect_data.remaining = remaining - step
		if effect_data.remaining <= 0.0:
			to_remove.append(i)
	for i in range(to_remove.size() - 1, -1, -1):
		_effects.pop_at(to_remove[i])

func active_count() -> int:
	return _effects.size()

func speed_multiplier() -> float:
	var multiplier := 1.0
	for effect_data in _effects:
		var effect = effect_data.effect as StatusEffect
		if effect is Slow:
			multiplier *= effect.multiplier
	return multiplier