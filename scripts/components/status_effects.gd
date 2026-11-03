class_name StatusEffects
extends Node

var _effects: Array = []

func add(effect: StatusEffect) -> void:
	var entry := {
		"effect": effect,
		"remaining": effect.duration
	}
	_effects.append(entry)

func tick(delta: float) -> void:
	var expired := []
	for i in range(_effects.size() - 1, -1, -1):
		var entry := _effects[i]
		var effect := entry["effect"] as StatusEffect
		var remaining := entry["remaining"] as float
		var step := min(delta, remaining)
		effect.apply_tick(get_parent(), step)
		remaining -= step
		if remaining <= 0.0:
			expired.append(i)
		else:
			entry["remaining"] = remaining
	for i in expired:
		_effects.remove_at(i)

func active_count() -> int:
	return _effects.size()

func speed_multiplier() -> float:
	var result := 1.0
	for entry in _effects:
		var effect := entry["effect"] as StatusEffect
		if effect is Slow:
			result *= effect.multiplier
	return result

func _physics_process(delta: float) -> void:
	tick(delta)