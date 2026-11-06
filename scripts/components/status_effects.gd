class_name StatusEffects
extends Node

var _effects: Array[Dictionary] = []

func add(effect: StatusEffect) -> void:
	_effects.append({"effect": effect, "elapsed": 0.0})

func tick(delta: float) -> void:
	var i := 0
	while i < _effects.size():
		var entry: Dictionary = _effects[i]
		var effect: StatusEffect = entry.effect
		var elapsed: float = entry.elapsed
		if elapsed < effect.duration:
			var remaining: float = effect.duration - elapsed
			var step: float = min(delta, remaining)
			effect.apply_tick(get_parent(), step)
			entry.elapsed = elapsed + step
			if entry.elapsed >= effect.duration:
				_effects.remove_at(i)
				continue
		i += 1

func active_count() -> int:
	return _effects.size()

func speed_multiplier() -> float:
	var result: float = 1.0
	for entry in _effects:
		var effect: StatusEffect = entry.effect
		if effect is Slow:
			result *= effect.multiplier
	return result