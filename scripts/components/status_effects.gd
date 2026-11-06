class_name StatusEffects extends Node

var _effects: Array[StatusEffect] = []

func add(effect: StatusEffect) -> void:
	_effects.append(effect)

func tick(delta: float) -> void:
	var new_effects: Array[StatusEffect] = []
	
	for effect in _effects:
		var remaining_time := effect.duration
		if remaining_time > 0:
			var step = min(delta, remaining_time)
			effect.apply_tick(get_parent(), step)
			remaining_time -= step
			
			if remaining_time > 0:
				new_effects.append(effect)
	
	_effects = new_effects

func active_count() -> int:
	return _effects.size()

func speed_multiplier() -> float:
	var multiplier := 1.0
	
	for effect in _effects:
		if effect is Slow:
			multiplier *= effect.multiplier
	
	return multiplier