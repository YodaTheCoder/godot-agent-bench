class_name StatusEffects
extends Node

type EffectEntry = {
	effect: StatusEffect,
	ticked_time: float
}

var _effects: Array[EffectEntry] = []

func _ready() -> void:
	set_physics_process(true)

func add(effect: StatusEffect) -> void:
	var entry: EffectEntry = {
		"effect": effect,
		"ticked_time": 0.0
	}
	_effects.append(entry)

func tick(delta: float) -> void:
	for entry in _effects:
		var remaining := entry.effect.duration - entry.ticked_time
		var step = min(delta, remaining)
		entry.effect.apply_tick(get_parent(), step)
		entry.ticked_time += step
	
	var to_remove: Array[EffectEntry] = []
	for entry in _effects:
		if entry.ticked_time >= entry.effect.duration:
			to_remove.append(entry)
	
	for entry in to_remove:
		_effects.erase(entry)

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