class_name StatusEffects extends Node

var _active_effects: Array[StatusEffect] = []
var _remaining_durations: Array[float] = []

func add(effect: StatusEffect) -> void:
	_active_effects.append(effect)
	_remaining_durations.append(effect.duration)

func tick(delta: float) -> void:
	for i in range(_active_effects.size() - 1, -1, -1):
		var step = min(delta, _remaining_durations[i])
		_active_effects[i].apply_tick(get_parent(), step)
		_remaining_durations[i] -= step
		
		if _remaining_durations[i] <= 0:
			_active_effects.remove_at(i)
			_remaining_durations.remove_at(i)

func active_count() -> int:
	return _active_effects.size()

func speed_multiplier() -> float:
	var multiplier = 1.0
	for effect in _active_effects:
		if effect is Slow:
			multiplier *= effect.multiplier
	return multiplier

func _physics_process(delta: float) -> void:
	tick(delta)
