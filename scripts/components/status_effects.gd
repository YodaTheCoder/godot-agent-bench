class_name StatusEffects extends Node

var _effects : Array = []
var _elapsed_times : Dictionary = {}

func _physics_process(delta: float) -> void:
	tick(delta)

func add(effect: StatusEffect) -> void:
	_effects.append(effect)
	_elapsed_times[effect] = 0.0

func tick(delta: float) -> void:
	var to_remove : Array = []
	for effect in _effects:
		var before_elapsed := _elapsed_times.get(effect, 0.0)
		var remaining := effect.duration - before_elapsed
		if remaining <= 0.0:
			to_remove.append(effect)
		else:
			var step := min(delta, remaining)
			effect.apply_tick(get_parent(), step)
			var after_elapsed := before_elapsed + step
			_elapsed_times[effect] = after_elapsed
			if after_elapsed >= effect.duration:
				to_remove.append(effect)
	for effect in to_remove:
		_effects.erase(effect)
		_elapsed_times.erase(effect)

func active_count() -> int:
	return _effects.size()

func speed_multiplier() -> float:
	var result := 1.0
	for effect in _effects:
		if effect is Slow:
			result *= (effect as Slow).multiplier
	return result