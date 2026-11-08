extends Node

class_name StatusEffects

var active_effects := []

func add(effect: StatusEffect) -> void:
	active_effects.append({
		"effect": effect,
		"time_remaining": effect.duration
	})

func tick(delta: float) -> void:
	var i := 0
	while i < active_effects.size():
		var effect_data = active_effects[i]
		var step := min(delta, effect_data.time_remaining)
		effect_data.effect.apply_tick(get_parent(), step)
		effect_data.time_remaining -= step
		
		if effect_data.time_remaining <= 0:
			active_effects.remove_at(i)
		else:
			i += 1

func active_count() -> int:
	return active_effects.size()

func speed_multiplier() -> float:
	var multiplier := 1.0
	for effect_data in active_effects:
		if effect_data.effect is Slow:
			multiplier *= effect_data.effect.multiplier
	
	return multiplier

func _physics_process(delta: float) -> void:
	tick(delta)