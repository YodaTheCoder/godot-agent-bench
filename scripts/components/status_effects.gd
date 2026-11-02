class_name StatusEffects
extends Node

var _elapsed: Array[float] = []
var _effects: Array[StatusEffect] = []

func add(effect: StatusEffect) -> void:
	_effects.append(effect)
	_elapsed.append(0.0)

func tick(delta: float) -> void:
	for i in range(_effects.size() - 1, -1, -1):
		var effect := _effects[i]
		var elapsed := _elapsed[i]
		var remaining := effect.duration - elapsed
		if remaining <= 0.0:
			continue
		var step := min(delta, remaining)
		effect.apply_tick(get_parent(), step)
		_elapsed[i] = elapsed + step
		if _elapsed[i] >= effect.duration:
			_elapsed.remove_at(i)
			_effects.remove_at(i)

func active_count() -> int:
	return _effects.size()

func speed_multiplier() -> float:
	var result := 1.0
	for effect in _effects:
		if effect is Slow:
			result *= effect.multiplier
	return result

func _physics_process(delta: float) -> void:
	tick(delta)