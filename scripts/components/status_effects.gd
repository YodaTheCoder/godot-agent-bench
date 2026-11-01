class_name StatusEffects
extends Node

var _active : Array = [] # array of dict { effect: StatusEffect, elapsed: float }

func add(effect: StatusEffect) -> void:
	var entry = {
		"effect": effect,
		"elapsed": 0.0
	}
	_active.append(entry)

func tick(delta: float) -> void:
	var parent = get_parent()
	var to_remove : Array = []
	for i in range(_active.size()):
		var entry = _active[i]
		var effect : StatusEffect = entry["effect"]
		var elapsed : float = entry["elapsed"]
		var remaining = effect.duration - elapsed
		if remaining <= 0:
			continue
		var step = min(delta, remaining)
		effect.apply_tick(parent, step)
		entry["elapsed"] = elapsed + step
		if entry["elapsed"] >= effect.duration:
			to_remove.append(i)
	# remove in reverse to not shift indices
	for idx in to_remove:
		_active.remove_at(idx)

func active_count() -> int:
	return _active.size()

func speed_multiplier() -> float:
	var mul = 1.0
	for entry in _active:
		var e = entry["effect"]
		if e is Slow:
			mul *= e.multiplier
	return mul

func _physics_process(delta: float) -> void:
	# tick status effects each physics frame
	self.tick(delta)
