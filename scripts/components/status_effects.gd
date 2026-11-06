class_name StatusEffects
extends Node

var _effects: Array = []

func add(effect: StatusEffect) -> void:
	var entry = {
		"effect": effect,
		"remaining": effect.duration
	}
	_effects.append(entry)

func tick(delta: float) -> void:
	var i := 0
	while i < _effects.size():
		var entry := _effects[i]
		var remaining := entry.remaining
		var step := min(delta, remaining)
		entry.effect.apply_tick(get_parent(), step)
		var new_remaining := remaining - step
		if new_remaining <= 0:
			_effects.remove_at(i)
		else:
			entry.remaining = new_remaining
			i += 1

func active_count() -> int:
	return _effects.size()

func speed_multiplier() -> float:
	var result := 1.0
	for entry in _effects:
		var effect := entry.effect
		if effect is Slow:
			result *= effect.multiplier
	return result


func _physics_process(delta: float) -> void:
	tick(delta)