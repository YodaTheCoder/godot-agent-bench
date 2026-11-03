class_name Poison
extends StatusEffect

@export var damage_per_second := 5.0

var damage_owed := 0.0

func apply_tick(target: Node, delta: float) -> void:
    if not target:
        return
    
    var health_node = target.get_node("Health")
    if not health_node:
        return
    
    damage_owed += damage_per_second * delta
    var damage_to_deal = int(damage_owed)
    if damage_to_deal > 0:
        health_node.damage(damage_to_deal)
        damage_owed -= damage_to_deal
