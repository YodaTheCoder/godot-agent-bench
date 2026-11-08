class_name StatusEffects extends Node

var _elapsed_times: Array[float] = []
var _effects: Array[StatusEffect] = []


func _physics_process(delta: float) -> void:
	tick(delta)

func add(effect: StatusEffect) -> void:
	_effects.append(effect)
	_elapsed_times.append(0.0)

func tick(delta: float) -> void:
	var i := 0
	while i < _effects.size():
		var effect := _effects[i] as StatusEffect
		var elapsed := _elapsed_times[i]
		var remaining := effect.duration - elapsed
		var step := min(delta, remaining)
		
		effect.apply_tick(get_parent(), step)
		
		if step == remaining:
			_effects.remove_at(i)
			_elapsed_times.remove_at(i)
		else:
			_elapsed_times[i] = elapsed + step
			i += 1

func active_count() -> int:
	return _effects.size()

func speed_multiplier() -> float:
	var result := 1.0
	for i in range(_effects.size()):
		if _effects[i] is Slow:
			result *= (_effects[i] as Slow).multiplier
	return result