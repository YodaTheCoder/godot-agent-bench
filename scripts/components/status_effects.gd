class_name StatusEffects
extends Node

class _ActiveEffect:
	var effect: StatusEffect
	var elapsed := 0.0

var _active_effects: Array = []

func add(effect: StatusEffect) -> void:
	var active = _ActiveEffect.new()
	active.effect = effect
	_active_effects.push_back(active)

func tick(delta: float) -> void:
	var to_remove: Array = []
	for i in range(_active_effects.size()):
		var active = _active_effects[i]
		var remaining = active.effect.duration - active.elapsed
		var step = min(delta, remaining)
		active.effect.apply_tick(get_parent(), step)
		active.elapsed += step
		if active.elapsed >= active.effect.duration:
			to_remove.push_back(i)
	for i in range(to_remove.size() - 1, -1, -1):
		_active_effects.pop_at(to_remove[i])

func _physics_process(delta: float) -> void:
	tick(delta)

func active_count() -> int:
	return _active_effects.size()

func speed_multiplier() -> float:
	var result := 1.0
	for active in _active_effects:
		if active.effect is Slow:
			result *= active.effect.multiplier
	return result