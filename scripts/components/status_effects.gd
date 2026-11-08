class_name StatusEffects
extends Node

var active_effects: Array[StatusEffect] = []

func add(effect: StatusEffect) -> void:
	active_effects.append(effect)

func tick(delta: float) -> void:
	var i := 0
	while i < active_effects.size():
		var effect := active_effects[i]
		if effect.duration <= 0:
			active_effects.remove_at(i)
			continue
		
		var step := min(delta, effect.duration)
		effect.duration -= step
		effect.apply_tick(get_parent(), step)
		
		if effect.duration <= 0:
			active_effects.remove_at(i)
		else:
			i += 1

func active_count() -> int:
	return active_effects.size()

func speed_multiplier() -> float:
	var multiplier := 1.0
	for effect in active_effects:
		if effect is Slow:
			multiplier *= effect.multiplier
	return multiplier

func _physics_process(delta: float) -> void:
	tick(delta)