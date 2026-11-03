class_name Poison extends StatusEffect

@export var damage_per_second := 5.0

var _damage_owed := 0.0

func apply_tick(target: Node, delta: float) -> void:
	var health = target.get_node_or_null("Health")
	if health:
		_damage_owed += damage_per_second * delta
		var damage_to_deal = int(_damage_owed)
		if damage_to_deal > 0:
			health.damage(damage_to_deal)
			_damage_owed -= damage_to_deal
