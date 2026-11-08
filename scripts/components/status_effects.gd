class_name StatusEffects
extends Node

var effects := []

func add(effect: StatusEffect) -> void:
	effects.append({
		effect = effect,
		time_left = effect.duration
	})

func tick(delta: float) -> void:
	var i = 0
	while i < effects.size():
		var effect_data = effects[i]
		var step = min(delta, effect_data.time_left)
		effect_data.effect.apply_tick(get_parent(), step)
		effect_data.time_left -= step
		
		if effect_data.time_left <= 0:
			effects.remove_at(i)
		else:
			i += 1

func active_count() -> int:
	return effects.size()

func speed_multiplier() -> float:
	var multiplier := 1.0
	for effect_data in effects:
		if effect_data.effect is Slow:
			multiplier *= effect_data.effect.multiplier
	return multiplier

func _physics_process(delta: float) -> void:
	tick(delta)