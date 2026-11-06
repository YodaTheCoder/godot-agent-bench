class_name Poison
extends StatusEffect

@export var damage_per_second := 5.0

var _accumulated: float = 0.0

func apply_tick(target: Node, delta: float) -> void:
	var health := target.get_node_or_null("Health")
	if health == null:
		return
	_accumulated += damage_per_second * delta
	var damage := int(_accumulated)
	_accumulated -= damage
	if damage > 0:
		health.damage(damage)