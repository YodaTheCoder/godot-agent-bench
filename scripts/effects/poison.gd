class_name Poison extends StatusEffect

@export var damage_per_second := 5.0
var owes: float = 0.0

func apply_tick(target: Node, delta: float) -> void:
    owes += damage_per_second * delta
    if target.has_node("Health"):
        var health: Node = target.get_node("Health")
        if health.has_method("damage"):
            var dmg: int = int(floor(owes))
            if dmg > 0:
                health.damage(dmg)
                owes -= float(dmg)
