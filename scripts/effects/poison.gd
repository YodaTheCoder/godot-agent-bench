class_name Poison
extends StatusEffect

@export var damage_per_second := 5.0

var _pending_damage := 0.0

func apply_tick(target: Node, delta: float) -> void:
	var health := target.get_node_or_null("Health") as Health
	if health == null:
		return
	
	_pending_damage += damage_per_second * delta
	var damage_to_apply := int(_pending_damage)
	_pending_damage -= damage_to_apply
	
	if damage_to_apply > 0:
		health.damage(damage_to_apply)
