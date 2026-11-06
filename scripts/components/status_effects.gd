class_name StatusEffects extends Node

var _active_effects := []

func add(effect: StatusEffect) -> void:
	var effect_data = {
		"effect": effect,
		"remaining_time": effect.duration
	}
	_active_effects.append(effect_data)

func tick(delta: float) -> void:
	var effects_to_remove := []
	
	for effect_data in _active_effects:
		var effect = effect_data["effect"]
		var remaining_time = effect_data["remaining_time"]
		
		var step = min(delta, remaining_time)
		effect.apply_tick(get_parent(), step)
		
		remaining_time -= step
		
		if remaining_time <= 0:
			effects_to_remove.append(effect_data)
	
	for effect_data in effects_to_remove:
		_active_effects.remove(effect_data)

func active_count() -> int:
	return _active_effects.size()

func speed_multiplier() -> float:
	var multiplier := 1.0
	
	for effect_data in _active_effects:
		if effect_data["effect"] is Slow:
			multiplier *= effect_data["effect"].multiplier
			
	return multiplier