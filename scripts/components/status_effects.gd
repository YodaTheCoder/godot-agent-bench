class_name StatusEffects
extends Node

var _effects: Array[StatusEffect] = []
var _remaining_times: Dictionary = {}

func add(effect: StatusEffect) -> void:
	_effects.append(effect)
	_remaining_times[effect] = effect.duration

func tick(delta: float) -> void:
	var effects_to_remove := []
	
	for effect in _effects:
		if not _remaining_times.has(effect):
			continue
			
		var step := min(delta, _remaining_times[effect])
		_remaining_times[effect] -= step
		
		if effect is Poison:
			effect.apply_tick(get_parent(), step)
		elif effect is Slow:
			effect.apply_tick(get_parent(), step)
		
		if _remaining_times[effect] <= 0:
			effects_to_remove.append(effect)
	
	for effect in effects_to_remove:
		_effects.erase(effect)
		_remaining_times.erase(effect)

func active_count() -> int:
	return _effects.size()

func speed_multiplier() -> float:
	var multiplier := 1.0
	
	for effect in _effects:
		if effect is Slow:
			multiplier *= effect.multiplier
	
	return multiplier

func _physics_process(delta: float) -> void:
	tick(delta)