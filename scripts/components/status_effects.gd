class_name StatusEffects
extends Node

var _effects: Array[Dictionary] = []

func add(effect: StatusEffect) -> void:
	_effects.append({
		"effect": effect,
		"remaining": effect.duration,
		"total": effect.duration,
		"stack_multiplier": 1.0
	})

func tick(delta: float) -> void:
	var new_effects: Array[Dictionary] = []
	for e in _effects:
		var step: float = min(delta, e["remaining"])
		e["effect"].apply_tick(get_parent(), step)
		e["remaining"] -= step
		
		if e["remaining"] > 0:
			new_effects.append(e)
		# if completed, no need to keep it
		
	_effects = new_effects

func active_count() -> int:
	return _effects.size()

func speed_multiplier() -> float:
	var result: float = 1.0
	for e in _effects:
		if e["effect"] is Slow:
			result *= e["effect"].multiplier
	return result