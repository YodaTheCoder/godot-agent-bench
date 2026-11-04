class_name StatusEffects
extends Node

var _active_effects: Array = []
var _elapsed_time: Array = []

func add(effect: StatusEffect) -> void:
	_active_effects.append(effect)
	_elapsed_time.append(0.0)

func tick(delta: float) -> void:
	# Process effects in reverse order for safe removal
	var i = _active_effects.size() - 1
	while i >= 0:
		var effect = _active_effects[i]
		var elapsed = _elapsed_time[i]
		
		var remaining = effect.duration - elapsed
		var step = min(delta, remaining)
		
		effect.apply_tick(get_parent(), step)
		_elapsed_time[i] = elapsed + step
		
		# Remove effect if duration reached
		if _elapsed_time[i] >= effect.duration:
			_active_effects.remove_at(i)
			_elapsed_time.remove_at(i)
		
		i -= 1

func active_count() -> int:
	return _active_effects.size()

func speed_multiplier() -> float:
	var result: float = 1.0
	for effect in _active_effects:
		if effect is Slow:
			result *= effect.multiplier
	return result

func _physics_process(delta: float) -> void:
	tick(delta)
