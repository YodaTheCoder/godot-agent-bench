class_name StatusEffects
extends Node

var _effects: Array = []
var _remaining: Array = []

func add(effect: StatusEffect) -> void:
	_effects.append(effect)
	_remaining.append(effect.duration)

func tick(delta: float) -> void:
	var i := _effects.size() - 1
	while i >= 0:
		var remaining := _remaining[i]
		var step := min(delta, remaining)
		_remaining[i] = remaining - step
		_effects[i].apply_tick(get_parent(), step)
		if _remaining[i] <= 0.0:
			_effects.remove_at(i)
			_remaining.remove_at(i)
		i -= 1

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