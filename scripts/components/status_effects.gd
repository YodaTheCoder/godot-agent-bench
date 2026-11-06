class_name StatusEffects extends Node

var active_effects: Array[Dictionary] = []


func add(effect: StatusEffect) -> void:
	var effect_data = {
		"effect": effect,
		"time_left": effect.duration
	}
	active_effects.append(effect_data)


func tick(delta: float) -> void:
	for i in range(active_effects.size()):
		var effect_data = active_effects[i]
		var effect = effect_data["effect"]
		var time_left = effect_data["time_left"] 
		
		var step = min(delta, time_left)
		effect.apply_tick(get_parent(), step)
		
		effect_data["time_left"] = time_left - step
		
	# Remove effects that have completed
	active_effects = active_effects.filter(func(effect_data):
		return effect_data["time_left"] >= 0.0)


func active_count() -> int:
	return active_effects.size()


func speed_multiplier() -> float:
	var multiplier: float = 1.0
	for effect_data in active_effects:
		var effect = effect_data["effect"]
		if effect is Slow:
			multiplier *= effect.multiplier
	
	return multiplier


func _physics_process(delta: float) -> void:
	tick(delta)