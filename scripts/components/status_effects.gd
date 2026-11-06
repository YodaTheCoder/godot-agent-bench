class_name StatusEffects extends Node

var _elapsed:Dictionary = {}

func _ready() -> void:
	set_physics_process(true)

func add(effect: StatusEffect) -> void:
	_elapsed[effect] = 0.0

func _physics_process(delta: float) -> void:
	tick(delta)

func tick(delta: float) -> void:
	var to_remove: Array = []
	for effect in _elapsed.keys():
		var elapsed: float = _elapsed[effect]
		var remaining: float = effect.duration - elapsed
		var step: float = min(delta, remaining)
		effect.apply_tick(get_parent(), step)
		_elapsed[effect] = elapsed + step
		if _elapsed[effect] >= effect.duration:
			to_remove.append(effect)
	for effect in to_remove:
		_elapsed.erase(effect)

func active_count() -> int:
	return _elapsed.size()

func speed_multiplier() -> float:
	var result: float = 1.0
	for effect in _elapsed.keys():
		if effect is Slow:
			result *= effect.multiplier
	return result