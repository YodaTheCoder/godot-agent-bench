class_name StatusEffects extends Node

var _active_effects: Array = []

func add(effect: StatusEffect) -> void:
	_active_effects.append({
		"effect": effect,
		"remaining_time": effect.duration
	})

func tick(delta: float) -> void:
	var effects_to_remove = []
	for active in _active_effects:
		var step = min(delta, active.remaining_time)
		active.effect.apply_tick(get_parent(), step)
		active.remaining_time -= step
		if active.remaining_time <= 0:
			effects_to_remove.append(active)
	
	for active in effects_to_remove:
		_active_effects.erase(active)

func active_count() -> int:
	return _active_effects.size()

func speed_multiplier() -> float:
	var multiplier = 1.0
	for active in _active_effects:
		if active.effect is Slow:
			multiplier *= active.effect.multiplier
	return multiplier

func _physics_process(delta: float) -> void:
	tick(delta)
