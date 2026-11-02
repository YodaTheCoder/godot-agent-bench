class_name Poison extends StatusEffect

@export var damage_per_second := 5.0
var damage_owed := 0.0

func apply_tick(target: Node, delta: float) -> void:
	var health = target.get_node_or_null("Health")
	if health:
		damage_owed += damage_per_second * delta
		var damage_to_deal = int(damage_owed)
		if damage_to_deal > 0:
			health.damage(damage_to_deal)
			damage_owed -= float(damage_to_deal)
