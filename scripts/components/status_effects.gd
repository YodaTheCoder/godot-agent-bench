class_name StatusEffects
extends Node

var _effects := []
var _elapsed := []


func add(effect: StatusEffect) -> void:
	_effects.append(effect)
	_elapsed.append(0.0)


func tick(delta: float) -> void:
	var to_remove := []
	for i in range(_effects.size()):
		var effect := _effects[i]
		var remaining := effect.duration - _elapsed[i]
		var step := min(delta, remaining)

		effect.apply_tick(get_parent(), step)
		_elapsed[i] += step

		if _elapsed[i] >= effect.duration:
			to_remove.append(i)

	for i in range(to_remove.size() - 1, -1, -1):
		_effects.remove_at(to_remove[i])
		_elapsed.remove_at(to_remove[i])


func _physics_process(delta: float) -> void:
	tick(delta)


func active_count() -> int:
	return _effects.size()


func speed_multiplier() -> float:
	var result := 1.0
	for effect in _effects:
		if effect is Slow:
			result *= effect.multiplier
	return result
