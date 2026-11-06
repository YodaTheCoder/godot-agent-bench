class_name Poison
extends StatusEffect

@export var damage_per_second := 5.0

var _owed_damage := 0.0

func apply_tick(target: Node, delta: float) -> void:
	var health := target.get_node_or_null("Health") as Health
	if health == null:
		return
	_owed_damage += damage_per_second * delta
	var damage := int(_owed_damage)
	if damage > 0:
		health.damage(damage)
		_owed_damage -= damage