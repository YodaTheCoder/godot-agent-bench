class_name StatusEffects extends Node

var effects := []
var active_effects := []

func add(effect: StatusEffect) -> void:
	# Create a copy of the effect to avoid modifying the original
	var effect_copy = effect.duplicate()
	effect_copy.damage_owed = 0.0
	active_effects.append({
		"effect": effect_copy,
		"time_left": effect_copy.duration
	})

func tick(delta: float) -> void:
	for i in range(active_effects.size() - 1, -1, -1):
		var effect_data = active_effects[i]
		var step = min(delta, effect_data.time_left)
		
		effect_data.effect.apply_tick(get_parent(), step)
		effect_data.time_left -= step
		
		if effect_data.time_left <= 0:
			active_effects.remove_at(i)

func active_count() -> int:
	return active_effects.size()

func speed_multiplier() -> float:
	var multiplier = 1.0
	for effect_data in active_effects:
		if effect_data.effect is Slow:
			multiplier *= effect_data.effect.multiplier
	return multiplier

func _physics_process(delta: float) -> void:
	tick(delta)