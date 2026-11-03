class_name Poison
extends StatusEffect

@export var damage_per_second := 5.0

func apply_tick(target: Node, delta: float) -> void:
	var owed = owed_damage + damage_per_second * delta
	var dealable = floor(owed)
	if dealable > 0:
		var health_child = target.get_node_or_null("Health")
		if health_child != null:
			health_child.damage(dealable)
	owed_damage = owed - dealable