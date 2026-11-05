class_name StatusEffects
extends Node

var _effects := []

func add(effect: StatusEffect) -> void:
	_effects.append({
		"effect": effect,
		"ticked_time": 0.0
	})

func tick(delta: float) -> void:
	var to_remove := []
	for i in range(_effects.size()):
		var entry := _effects[i]
		var remaining := entry.effect.duration - entry.ticked_time
		var step := min(delta, remaining)
		entry.effect.apply_tick(get_parent(), step)
		entry.ticked_time += step
		if entry.ticked_time >= entry.effect.duration:
			to_remove.append(i)

	for i in range(to_remove.size() - 1, -1, -1):
		_effects.pop_at(to_remove[i])

func active_count() -> int:
	return _effects.size()

func speed_multiplier() -> float:
	var result := 1.0
	for entry in _effects:
		if entry.effect is Slow:
			result *= entry.effect.multiplier
	return result

func _physics_process(delta: float) -> void:
	tick(delta)
