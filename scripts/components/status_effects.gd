class_name StatusEffects extends Node

var _active_effects: Array[StatusEffect] = []
var _remaining_durations: Array[float] = []

func add(effect: StatusEffect) -> void:
	_active_effects.append(effect)
	_remaining_durations.append(effect.duration)

func tick(delta: float) -> void:
	var i := 0
	while i < _active_effects.size():
		var effect = _active_effects[i]
		var remaining = _remaining_durations[i]
		var step = min(delta, remaining)
		
		effect.apply_tick(get_parent(), step)
		_remaining_durations[i] -= step
		
		if _remaining_durations[i] <= 0:
			_active_effects.remove_at(i)
			_remaining_durations.remove_at(i)
		else:
			i += 1

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
