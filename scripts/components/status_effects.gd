class_name StatusEffects
extends Node

var _effects: Array = []

func add(effect: StatusEffect) -> void:
	var entry := {
		"effect": effect,
		"elapsed": 0.0
	}
	_effects.append(entry)

func tick(delta: float) -> void:
	var to_remove: Array = []
	for i in range(_effects.size()):
		var entry := _effects[i]
		var elapsed := entry.elapsed
		var duration := entry.effect.duration
		var remaining := duration - elapsed
		var step := min(delta, remaining)
		if step > 0:
			entry.effect.apply_tick(get_parent(), step)
		entry.elapsed += step
		if entry.elapsed >= duration:
			to_remove.append(i)
	for i in range(to_remove.size() - 1, -1, -1):
		_effects.remove_at(to_remove[i])

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