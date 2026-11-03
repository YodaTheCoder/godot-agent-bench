class_name StatusEffects extends Node

struct ActiveEffect:
	var effect: StatusEffect
	var remaining_time: float

var _active_effects: Array = []

func add(effect: StatusEffect) -> void:
	_active_effects.append({
		"effect": effect,
		"remaining_time": effect.duration
	})

func tick(delta: float) -> void:
	var i = 0
	while i < _active_effects.size():
		var data = _active_effects[i]
		var step = min(delta, data["remaining_time"])
		
		data["effect"].apply_tick(get_parent(), step)
		data["remaining_time"] -= step
		
		if data["remaining_time"] <= 0:
			_active_effects.remove_at(i)
		else:
			i += 1

func active_count() -> int:
	return _active_effects.size()

func speed_multiplier() -> float:
	var multiplier := 1.0
	for data in _active_effects:
		if data["effect"] is Slow:
			multiplier *= data["effect"].multiplier
	return multiplier

func _physics_process(delta: float) -> void:
	tick(delta)
