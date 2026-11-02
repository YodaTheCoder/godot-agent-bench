class_name Poison extends StatusEffect

@export var damage_per_second := 5.0

var _damage_owed := 0.0

func apply_tick(target: Node, delta: float) -> void:
	_damage_owed += damage_per_second * delta
	var damage_to_deal := int(_damage_owed)
	if damage_to_deal > 0:
		var health_node = target.get_node_or_null("Health")
		if health_node and health_node.has_method("damage"):
			health_node.damage(damage_to_deal)
		_damage_owed -= damage_to_deal
