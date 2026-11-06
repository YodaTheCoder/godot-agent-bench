class_name Poison
extends StatusEffect

@export var damage_per_second := 5.0

var _pending_damage := 0.0

func apply_tick(target: Node, delta: float) -> void:
	var health := target.get_nodeOrNull("Health")
	if health == null:
		return
	_pending_damage += damage_per_second * delta
	var damage_int := int(_pending_damage)
	if damage_int > 0:
		health.damage(damage_int)
		_pending_damage -= damage_int