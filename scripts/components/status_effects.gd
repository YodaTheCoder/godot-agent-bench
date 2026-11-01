class_name StatusEffects extends Node

var active_effects := []

func add(effect: StatusEffect) -> void:
	active_effects.append({
		"effect": effect,
		"remaining_time": effect.duration
	})

func tick(delta: float) -> void:
	var i = 0
	while i < active_effects.size():
		var effect_data = active_effects[i]
		var effect = effect_data.effect
		var remaining_time = effect_data.remaining_time
		
		var step := min(delta, remaining_time)
		effect.apply_tick(get_parent(), step)
		
		remaining_time -= step
		effect_data.remaining_time = remaining_time
		
		if remaining_time <= 0:
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