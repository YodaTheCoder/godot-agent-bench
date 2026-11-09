class_name StatusEffects
extends Node

var effects: Array[StatusEffect] = []
var effect_durations: Dictionary[StatusEffect, float] = {}

func add(effect: StatusEffect) -> void:
	effects.append(effect)
	effect_durations[effect] = effect.duration

func tick(delta: float) -> void:
	var effects_to_remove: Array[StatusEffect] = []
	
	for effect in effects:
		var time_remaining := effect_durations[effect]
		if time_remaining <= 0:
			effects_to_remove.append(effect)
			continue
			
		var step := min(delta, time_remaining)
		effect.apply_tick(get_parent(), step)
		
		time_remaining -= step
		effect_durations[effect] = time_remaining
		
		if time_remaining <= 0:
			effects_to_remove.append(effect)
	
	for effect in effects_to_remove:
		effects.erase(effect)
		effect_durations.erase(effect)

func active_count() -> int:
	return effects.size()

func speed_multiplier() -> float:
	var multiplier := 1.0
	for effect in effects:
		if effect is Slow:
			multiplier *= effect.multiplier
	return multiplier

func _physics_process(delta: float) -> void:
	tick(delta)