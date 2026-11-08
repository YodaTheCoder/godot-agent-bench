class_name StatusEffects extends Node

var _effects: Array[Dictionary] = []

func _physics_process(delta: float) -> void:
	tick(delta)

func add(effect: StatusEffect) -> void:
	_effects.append({
		"effect": effect,
		"remaining": effect.duration
	})

func tick(delta: float) -> void:
	var to_remove: Array[int] = []
	for i in range(_effects.size()):
		var entry := _effects[i]
		var remaining := entry.remaining
		if remaining <= 0.0:
			to_remove.append(i)
			continue
		var step := min(delta, remaining)
		entry.effect.apply_tick(get_parent(), step)
		entry.remaining = remaining - step
		if entry.remaining <= 0.0:
			to_remove.append(i)
	for i in to_remove.backwards():
		_effects.remove_at(i)

func active_count() -> int:
	return _effects.size()

func speed_multiplier() -> float:
	var result := 1.0
	for entry in _effects:
		if entry.effect is Slow:
			result *= entry.effect.multiplier
	return result