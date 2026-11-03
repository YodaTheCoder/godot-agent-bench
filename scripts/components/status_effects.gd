class_name StatusEffects
extends Node

var _active_effects: Array[Dictionary] = []

func add(effect: StatusEffect) -> void:
    var effect_data: Dictionary = {
        "effect": effect,
        "remaining_duration": effect.duration,
        "active": true
    }
    
    _active_effects.append(effect_data)

func tick(delta: float) -> void:
    var effects_to_remove: Array[Dictionary] = []
    
    for effect_data in _active_effects:
        if not effect_data["active"]:
            continue
            
        var effect = effect_data["effect"]
        var effect_delta = min(delta, effect_data["remaining_duration"])
        effect.apply_tick(get_parent(), effect_delta)
        effect_data["remaining_duration"] -= effect_delta
        
        if effect_data["remaining_duration"] <= 0:
            effect_data["active"] = false
            effects_to_remove.append(effect_data)
    
    for effect_data in effects_to_remove:
        var index = _active_effects.find(effect_data)
        if index != -1:
            _active_effects.remove_at(index)

func active_count() -> int:
    var count = 0
    for effect_data in _active_effects:
        if effect_data["active"]:
            count += 1
    return count

func speed_multiplier() -> float:
    var multiplier = 1.0
    for effect_data in _active_effects:
        if effect_data["active"] and effect_data["effect"] is Slow:
            multiplier *= effect_data["effect"].multiplier
    return multiplier

func _physics_process(delta: float):
    tick(delta)
