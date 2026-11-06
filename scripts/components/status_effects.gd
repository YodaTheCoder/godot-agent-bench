class_name StatusEffects
extends Node

# Represents an active effect with its remaining time
class ActiveEffect:
	var effect: StatusEffect
	var remaining_time: float
	
	func _init(effect_inst: StatusEffect, time: float):
		effect = effect_inst
		remaining_time = time

var _active_effects: Array[ActiveEffect] = []

func add(effect: StatusEffect) -> void:
	_active_effects.append(ActiveEffect.new(effect, effect.duration))

func tick(delta: float) -> void:
	var i = 0
	while i < _active_effects.size():
		var active_effect = _active_effects[i]
		var step = min(delta, active_effect.remaining_time)
		
		# Apply the effect
		active_effect.effect.apply_tick(get_parent(), step)
		
		# Update remaining time
		active_effect.remaining_time -= step
		
		# Remove the effect if its duration is over
		if active_effect.remaining_time <= 0:
			_active_effects.remove_at(i)
		else:
			i += 1

func active_count() -> int:
	return _active_effects.size()

func speed_multiplier() -> float:
	var multiplier = 1.0
	for active_effect in _active_effects:
		if active_effect.effect is Slow:
			multiplier *= active_effect.effect.multiplier
	return multiplier

func _physics_process(delta: float) -> void:
	tick(delta)