class_name Poison extends StatusEffect

@export var damage_per_second := 5.0

var leftover_damage := 0.0

func apply_tick(target: Node, delta: float) -> void:
	var health := target.get_node_or_null("Health") as Health
	if health == null:
		return
	leftover_damage += damage_per_second * delta
	var damage := int(leftover_damage)
	leftover_damage -= float(damage)
	health.damage(damage)