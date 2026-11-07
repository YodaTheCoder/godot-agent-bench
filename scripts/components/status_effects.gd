class_name StatusEffects extends Node

var active_effects := []

func add(effect: StatusEffect) -> void:
	var effect_data = {
		"effect": effect,
		"remaining_time": effect.duration
	}
	active_effects.append(effect_data)

func tick(delta: float) -> void:
	var i = 0
	while i < active_effects.size():
		var effect_data = active_effects[i]
		var effect = effect_data.effect
		var remaining_time = effect_data.remaining_time
		
		# Calculate how much time to apply this tick for
		var step = min(delta, remaining_time)
		
		# Apply the effect
		effect.apply_tick(get_parent(), step)
		
		# Update remaining time
		remaining_time -= step
		
		# Check if effect has expired
		if remaining_time <= 0:
			active_effects.remove_at(i)
		else:
			effect_data.remaining_time = remaining_time
			i += 1

func active_count() -> int:
	return active_effects.size()

func speed_multiplier() -> float:
	var multiplier := 1.0
	for effect_data in active_effects:
		var effect = effect_data.effect
		if effect is Slow:
			multiplier *= effect.multiplier
	return multiplier

func _physics_process(delta: float) -> void:
	tick(delta)