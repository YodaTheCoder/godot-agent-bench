class_name StatusEffects extends Node

var _active_effects: Array[StatusEffect] = []
var _remaining_times: Array[float] = []

func add(effect: StatusEffect) -> void:
	_active_effects.append(effect)
	_remaining_times.append(effect.duration)

func tick(delta: float) -> void:
	var effects_to_remove: Array[int] = []
	
	for i in range(_active_effects.size()):
		var step = min(delta, _remaining_times[i])
		_active_effects[i].apply_tick(get_parent(), step)
		_remaining_times[i] -= step
		
		if _remaining_times[i] <= 0:
			effects_to_remove.append(i)
	
	# Remove effects in reverse order to not invalidate indices
	for i in range(effects_to_remove.size() - 1, -1, -1):
		var idx = effects_to_remove[i]
		_active_effects.remove_at(idx)
		_remaining_times.remove_at(idx)

func active_count() -> int:
	return _active_effects.size()

func speed_multiplier() -> float:
	var multiplier := 1.0
	for effect in _active_effects:
		if effect is Slow:
			multiplier *= effect.multiplier
	return multiplier

func _physics_process(delta: float) -> void:
	tick(delta)
