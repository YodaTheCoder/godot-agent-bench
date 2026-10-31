class EffectInstance:
	var effect: StatusEffect
	var remaining_duration: float

var effects: Array[EffectInstance] = []

func add(effect: StatusEffect) -> void:
	var effect_instance = EffectInstance.new()
	effect_instance.effect = effect
	effect_instance.remaining_duration = effect.duration
	effects.append(effect_instance)

func tick(delta: float) -> void:
	for i in range(effects.size() - 1, -1, -1):
		var effect_instance = effects[i]
		if not effect_instance.effect:
			effects.remove_at(i)
			continue
		
		# Apply the effect for the minimum of delta or remaining duration
		var step = min(delta, effect_instance.remaining_duration)
		effect_instance.effect.apply_tick(get_parent(), step)
		
		# Decrease remaining duration
		effect_instance.remaining_duration -= step
		
		# Remove effect if it's completed
		if effect_instance.remaining_duration <= 0:
			effects.remove_at(i)

func active_count() -> int:
	return effects.size()

func speed_multiplier() -> float:
	var multiplier = 1.0
	for effect_instance in effects:
		if effect_instance.effect is Slow:
			multiplier *= effect_instance.effect.multiplier
	return multiplier