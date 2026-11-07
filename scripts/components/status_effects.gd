extends Node
class_name StatusEffects

var effects := []

func add(effect: StatusEffect) -> void:
	effects.append({
		"effect": effect,
		"remaining_time": effect.duration
	})

func tick(delta: float) -> void:
	var i = 0
	while i < effects.size():
		var effect_data = effects[i]
		var step = min(delta, effect_data.remaining_time)
		
		effect_data.effect.apply_tick(get_parent(), step)
		effect_data.remaining_time -= step
		
		if effect_data.remaining_time <= 0:
			effects.remove_at(i)
		else:
			i += 1

func active_count() -> int:
	return effects.size()

func speed_multiplier() -> float:
	var multiplier = 1.0
	for effect_data in effects:
		if effect_data.effect is Slow:
			multiplier *= effect_data.effect.multiplier
	
	return multiplier

func _physics_process(delta: float) -> void:
	tick(delta)