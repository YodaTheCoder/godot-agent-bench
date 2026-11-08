class_name StatusEffects extends Node

var _effects: Array = []

func _physics_process(delta: float) -> void:
	tick(delta)

func add(effect: StatusEffect) -> void:
	_effects.append({effect = effect, remaining = effect.duration})

func tick(delta: float) -> void:
	var to_remove: Array = []
	for i in range(_effects.size()):
		var entry := _effects[i]
		var step := mini(delta, entry.remaining)
		entry.effect.apply_tick(get_parent(), step)
		entry.remaining -= step
		if entry.remaining <= 0:
			to_remove.append(i)
	for i in range(to_remove.size() - 1, -1, -1):
		_effects.pop_at(to_remove[i])

func active_count() -> int:
	return _effects.size()

func speed_multiplier() -> float:
	var result := 1.0
	for entry in _effects:
		if entry.effect is Slow:
			result *= (entry.effect as Slow).multiplier
	return result