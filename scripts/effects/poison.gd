class_name Poison
extends StatusEffect

@export var damage_per_second := 5.0

var _damage_owed: float = 0.0

func apply_tick(target: Node, delta: float) -> void:
	var health = target.get_node_or_null("Health") as Health
	if health == null:
		return
	
	_damage_owed += damage_per_second * delta
	var damage_to_deal = int(_damage_owed)
	health.damage(damage_to_deal)
	_damage_owed -= damage_to_deal
