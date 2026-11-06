class_name StatusEffects
extends Node

var _effects: Array = []

func _ready() -> void:
	set_physics_process(true)

func add(effect: StatusEffect) -> void:
	_effects.append({effect = effect, remaining = effect.duration})

func tick(delta: float) -> void:
	var to_remove: Array = []
	for i in range(_effects.size() - 1, -1, -1):
		var entry = _effects[i]
		if entry == null:
			to_remove.append(i)
			continue
		var step := min(delta, entry.remaining)
		entry.effect.apply_tick(get_parent(), step)
		entry.remaining -= step
		if entry.remaining <= 0.0:
			to_remove.append(i)
	for i in to_remove:
		_effects.remove_at(i)

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