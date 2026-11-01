class_name Poison
extends StatusEffect

@export var damage_per_second := 5.0

func apply_tick(target: Node, delta: float) -> void:
    if not target:
        return
    
    var health_node = target.get_node_or_null("Health")
    if not health_node:
        return
    
    if damage_per_second <= 0:
        return
    
    var owed_damage = health_node.get("owed_damage") if hasattr(health_node, "owed_damage") else 0.0
    owed_damage += damage_per_second * delta
    
    var damage_to_deal = int(owed_damage)
    if damage_to_deal > 0:
        health_node.damage(damage_to_deal)
        owed_damage -= float(damage_to_deal)
        health_node.set("owed_damage", owed_damage)