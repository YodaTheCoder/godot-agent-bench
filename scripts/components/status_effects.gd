class_name StatusEffects
extends Node

var active_effects: Array[StatusEffect] = []


func add(effect: StatusEffect) -> void:
    if not effect:
        return
    
    if effect is Slow:
        active_effects.append(effect)
    else:
        active_effects.append(effect)
    
    active_effects.sort_custom(sort_by_remaining_time)


func tick(delta: float) -> void:
    var i: int = 0
    while i < active_effects.size():
        var effect: StatusEffect = active_effects[i]
        var remaining_time: float = effect.get("remaining_time", 0.0)
        var step: float = min(delta, effect.duration - remaining_time)
        
        effect.apply_tick(get_parent(), step)
        
        if remaining_time + step >= effect.duration:
            active_effects.remove_at(i)
        else:
            effect.set("remaining_time", remaining_time + step)
            i += 1


func active_count() -> int:
    return active_effects.size()


func speed_multiplier() -> float:
    var multiplier: float = 1.0
    for effect in active_effects:
        if effect is Slow:
            multiplier *= effect.multiplier
    return multiplier


func sort_by_remaining_time(a: StatusEffect, b: StatusEffect) -> bool:
    var a_remaining: float = a.get("remaining_time", a.duration)
    var b_remaining: float = b.get("remaining_time", b.duration)
    return a_remaining < b_remaining