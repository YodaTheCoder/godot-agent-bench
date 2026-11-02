class_name StatusEffects extends Node

var _effects := []

func add(effect: StatusEffect) -> void:
    # Create a mutable copy to track remaining time
    var data = {
        "effect": effect,
        "remaining": effect.duration
    }
    _effects.append(data)

func tick(delta: float) -> void:
    var to_remove := []
    for data in _effects:
        if data["remaining"] < 1e-9:
            to_remove.append(data)
            continue
        var step = min(delta, data["remaining"])
        var e: StatusEffect = data["effect"]
        e.apply_tick(get_parent(), step)
        data["remaining"] -= step
    for r in to_remove:
        _effects.erase(r)

func active_count() -> int:
    return _effects.size()

func speed_multiplier() -> float:
    var mult := 1.0
    for data in _effects:
        var e: StatusEffect = data["effect"]
        if e is Slow:
            mult *= e.multiplier
    return mult

func _physics_process(delta: float) -> void:
    tick(delta)
