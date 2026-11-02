class_name StatusEffects

extends Node

# Internal structure: Array of dictionaries { effect: StatusEffect, elapsed: float }
var _data : Array[Dictionary] = []

func add(effect: StatusEffect) -> void:
    _data.append({"effect": effect, "elapsed": 0.0})

func tick(delta: float) -> void:
    var target : Node = get_parent()
    var to_remove : Array[int] = []
    for i in range(_data.size()):
        var entry = _data[i]
        var effect : StatusEffect = entry["effect"]
        var elapsed : float = entry["elapsed"]
        var remaining : float = effect.duration - elapsed
        var step : float = min(delta, remaining)
        effect.apply_tick(target, step)
        entry["elapsed"] = elapsed + step
        if entry["elapsed"] >= effect.duration:
            to_remove.append(i)
    # remove from back to maintain indexes
    for idx in to_remove.invert():
        _data.remove(idx)

func active_count() -> int:
    return _data.size()

func speed_multiplier() -> float:
    var mult : float = 1.0
    for entry in _data:
        var effect : StatusEffect = entry["effect"]
        if effect is Slow:
            var slow : Slow = effect as Slow
            mult *= slow.multiplier
    return mult

func _physics_process(delta: float) -> void:
    tick(delta)
