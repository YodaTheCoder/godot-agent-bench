class_name Poison
extends StatusEffect

@export var damage_per_second := 5.0

var pending_damage: float = 0.0

func apply_tick(target: Node, delta: float) -> void:
	var health = target.get_node_or_null("Health") as Health
	if health == null:
		return
	
	pending_damage += damage_per_second * delta
	var damage_to_apply = int(pending_damage)
	if damage_to_apply > 0:
		health.damage(damage_to_apply)
		pending_damage = pending_damage - damage_to_apply
