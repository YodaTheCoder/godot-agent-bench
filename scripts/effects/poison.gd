class_name Poison
extends StatusEffect

@export var damage_per_second := 5.0

## Damage owed but not yet dealt (Health only takes whole points).
var _pending := 0.0


func apply_tick(target: Node, delta: float) -> void:
	var health := target.get_node_or_null("Health") as Health
	if health == null:
		return
	_pending += damage_per_second * delta
	var whole := floori(_pending)
	if whole > 0:
		_pending -= whole
		health.damage(whole)
