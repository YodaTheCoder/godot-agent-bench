class_name StatusEffects
extends Node

var _effects: Array = []

func add(effect: StatusEffect) -> void:
	_effects.append({
		"effect": effect,
		"elapsed": 0.0
	})

func tick(delta: float) -> void:
	var to_remove: Array = []
	
	for i in range(_effects.size() - 1, -1, -1):
		var entry = _effects[i]
		var effect = entry["effect"]
		var elapsed = entry["elapsed"]
		
		var remaining = effect.duration - elapsed
		if remaining <= 0.0:
			to_remove.append(i)
			continue
		
		var step = min(delta, remaining)
		effect.apply_tick(get_parent(), step)
		
		elapsed += step
		entry["elapsed"] = elapsed
		
		if elapsed >= effect.duration:
			to_remove.append(i)
	
	for i in to_remove:
		_effects.remove_at(i)

func active_count() -> int:
	return _effects.size()

func speed_multiplier() -> float:
	var result: float = 1.0
	for entry in _effects:
		var effect = entry["effect"]
		if effect is Slow:
			result *= effect.multiplier
	return result

func _physics_process(delta: float) -> void:
	tick(delta)
