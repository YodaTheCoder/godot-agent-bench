class_name StatusEffects extends Node

var _effects: Array[Dictionary] = []

func add(effect: StatusEffect) -> void:
	var data := {
		"effect": effect,
		"elapsed": 0.0
	}
	_effects.append(data)

func tick(delta: float) -> void:
	var i := 0
	while i < _effects.size():
		var data := _effects[i]
		var remaining := data.effect.duration - data.elapsed
		var step = min(delta, remaining)
		if step > 0:
			data.effect.apply_tick(get_parent(), step)
		data.elapsed += step
		if data.elapsed >= data.effect.duration:
			_effects.remove_at(i)
		else:
			i += 1

func active_count() -> int:
	return _effects.size()

func speed_multiplier() -> float:
	var result := 1.0
	for data in _effects:
		if data.effect is Slow:
			result *= data.effect.multiplier
	return result

func _physics_process(delta: float) -> void:
	tick(delta)