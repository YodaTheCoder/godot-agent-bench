extends Node

class_name StatusEffects

var _active_effects: Array[Dictionary] = []

func add(effect: StatusEffect) -> void:
	_active_effects.append({
		"effect": effect,
		"elapsed": 0.0
	})

func tick(delta: float) -> void:
	var to_remove: Array[int] = []
	for i in _active_effects.size():
		var entry := _active_effects[i]
		var remaining := entry.effect.duration - entry.elapsed
		if remaining <= 0.0:
			to_remove.append(i)
			continue
		var step := min(delta, remaining)
		entry.effect.apply_tick(get_parent(), step)
		entry.elapsed += step
		if entry.elapsed >= entry.effect.duration:
			to_remove.append(i)
	for i in range(to_remove.size() - 1, -1, -1):
		_active_effects.remove_at(to_remove[i])

func active_count() -> int:
	return _active_effects.size()

func speed_multiplier() -> float:
	var result := 1.0
	for entry in _active_effects:
		if entry.effect is Slow:
			result *= entry.effect.multiplier
	return result

func _physics_process(delta: float) -> void:
	tick(delta)