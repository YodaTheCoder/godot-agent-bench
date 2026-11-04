class_name StatusEffects
extends Node

var _active_effects: Array = [] # Array of dictionaries: {"effect": StatusEffect, "elapsed": float}

func add(effect: StatusEffect) -> void:
	_active_effects.append({
		"effect": effect,
		"elapsed": 0.0
	})

func tick(delta: float) -> void:
	var to_remove: Array = []
	
	for entry in _active_effects:
		var remaining_time: float = entry.effect.duration - entry.elapsed
		var step: float = min(delta, remaining_time)
		
		entry.effect.apply_tick(get_parent(), step)
		
		entry.elapsed += step
		
		if entry.elapsed >= entry.effect.duration:
			to_remove.append(entry)
	
	for entry in to_remove:
		_active_effects.erase(entry)

func _physics_process(delta: float) -> void:
	tick(delta)

func active_count() -> int:
	return _active_effects.size()

func speed_multiplier() -> float:
	var result: float = 1.0
	for entry in _active_effects:
		if entry.effect is Slow:
			result *= entry.effect.multiplier
	return result
