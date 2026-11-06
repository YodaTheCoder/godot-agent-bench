class_name StatusEffects
extends Node

var active_effects: Array[Dictionary] = []

func _physics_process(delta: float) -> void:
	tick(delta)

func add(effect: StatusEffect) -> void:
	var effect_data := {
		"effect": effect,
		"time_left": effect.duration
	}
	active_effects.append(effect_data)

func tick(delta: float) -> void:
	var i := 0
	while i < active_effects.size():
		var effect_data := active_effects[i]
		var effect: StatusEffect = effect_data["effect"]
		var time_left: float = effect_data["time_left"]
		
		var step := min(delta, time_left)
		effect.apply_tick(get_parent(), step)
		
		time_left -= step
		effect_data["time_left"] = time_left
		
		if time_left <= 0:
			active_effects.remove_at(i)
		else:
			i += 1

func active_count() -> int:
	return active_effects.size()

func speed_multiplier() -> float:
	var multiplier := 1.0
	for effect_data in active_effects:
		var effect: StatusEffect = effect_data["effect"]
		if effect is Slow:
			multiplier *= effect.multiplier
	return multiplier