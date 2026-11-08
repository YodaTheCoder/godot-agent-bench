class_name StatusEffects
extends Node

var _effects: Array = []

func add(effect: StatusEffect) -> void:
	_effects.append({
		"effect": effect,
		"used_time": 0.0
	})

func tick(delta: float) -> void:
	var to_remove: Array = []
	for i in range(_effects.size()):
		var entry := _effects[i]
		var effect := entry.effect as StatusEffect
		var used_time := entry.used_time as float
		
		var remaining := effect.duration - used_time
		if remaining <= 0.0:
			to_remove.append(i)
			continue
		
		var step := min(delta, remaining)
		effect.apply_tick(get_parent(), step)
		entry.used_time = used_time + step
		
		if entry.used_time >= effect.duration:
			to_remove.append(i)
	
	for i in range(to_remove.size() - 1, -1, -1):
		_effects.remove_at(to_remove[i])

func active_count() -> int:
	return _effects.size()

func speed_multiplier() -> float:
	var result := 1.0
	for entry in _effects:
		var effect := entry.effect
		if effect is Slow:
			result *= effect.multiplier
	return result

func _physics_process(delta: float) -> void:
	tick(delta)