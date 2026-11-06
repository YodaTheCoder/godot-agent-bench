extends Node

class_name StatusEffects

var _active_effects := []

func add(effect: StatusEffect) -> void:
	var effect_data := {
		effect = effect,
		time_left = effect.duration
	}
	_active_effects.append(effect_data)

func tick(delta: float) -> void:
	for i in range(_active_effects.size() - 1, -1, -1):
		var effect_data = _active_effects[i]
		
		var step := min(delta, effect_data.time_left)
		effect_data.effect.apply_tick(get_parent(), step)
		
		effect_data.time_left -= step
		
		if effect_data.time_left <= 0:
			_active_effects.remove_at(i)

func active_count() -> int:
	return _active_effects.size()

func speed_multiplier() -> float:
	var multiplier := 1.0
	
	for effect_data in _active_effects:
		if effect_data.effect is Slow:
			multiplier *= effect_data.effect.multiplier
	
	return multiplier