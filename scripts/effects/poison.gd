class_name Poison
extends StatusEffect

@export var damage_per_second := 5.0

var _remaining_damage: float := 0.0

func apply_tick(target: Node, delta: float) -> void:
	var health := target.get_node_or_null("Health") as Health
	if health == null:
		return
	_remaining_damage += damage_per_second * delta
	var damage_to_deal := int(_remaining_damage)
	if damage_to_deal > 0:
		health.damage(damage_to_deal)
		_remaining_damage -= damage_to_deal