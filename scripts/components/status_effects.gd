class_name StatusEffects
extends Node

var _active_effects := []

func add(effect: StatusEffect) -> void:
	var effect_data = {
		effect = effect,
		remaining_time = effect.duration
	}
	_active_effects.append(effect_data)

func tick(delta: float) -> void:
	var i = 0
	while i < _active_effects.size():
		var effect_data = _active_effects[i]
		var step = min(delta, effect_data.remaining_time)
		
		effect_data.effect.apply_tick(get_parent(), step)
		effect_data.remaining_time -= step
		
		if effect_data.remaining_time >= effect.duration:
			_active_effects.remove_at(i)
		else:
			i += 1

func active_count() -> int:
	return _active_effects.size()

func speed_multiplier() -> float:
	var multiplier := 1.0
	for effect_data in _active_effects:
		if effect_data.effect is Slow:
			multiplier *= effect_data.effect.multiplier
	
	return multiplier

func _physics_process(delta: float) -> void:
	tick(delta)