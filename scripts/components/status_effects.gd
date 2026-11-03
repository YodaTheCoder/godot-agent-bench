class_name StatusEffects
extends Node

var active_effects: Array[StatusEffect] = []
var remaining_time: Dictionary = {}

func add(effect: StatusEffect) -> void:
	active_effects.append(effect)
	remaining_time[effect] = effect.duration

func tick(delta: float) -> void:
	var effects_to_remove: Array[StatusEffect] = []
	for effect in active_effects:
		if remaining_time[effect] <= 0:
			effects_to_remove.append(effect)
			continue
		let step = min(delta, remaining_time[effect])
		effect.apply_tick(get_parent(), step)
		remaining_time[effect] -= step
		if remaining_time[effect] <= 0:
			effects_to_remove.append(effect)

	for effect in effects_to_remove:
		active_effects.erase(effect)
		if remaining_time.has(effect):
			remaining_time.erase(effect)

func active_count() -> int:
	return active_effects.size()

func speed_multiplier() -> float:
	var multiplier: float = 1.0
	for effect in active_effects:
		if effect is Slow:
			multiplier *= effect.multiplier
	return multiplier