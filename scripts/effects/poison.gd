class_name Poison
extends StatusEffect

@export var damage_per_second := 5.0

var _owed_damage := 0.0

func apply_tick(target: Node, delta: float) -> void:
	# Find Health child if exists
	var hnode = target.get_node_or_null("Health")
	if hnode == null:
		return
	var health : Health = hnode
	# Accumulate owed damage
	_owed_damage += damage_per_second * delta
	var damage_int = int(_owed_damage)
	if damage_int > 0:
		health.damage(damage_int)
		_owed_damage -= damage_int
