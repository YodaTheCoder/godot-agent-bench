class_name Poison
extends StatusEffect

## Small tolerance so float drift (e.g. 0.1 + 0.1 + ...) doesn't lose a point of damage.
const EPSILON := 1e-6

@export var damage_per_second := 5.0

# Health only takes integer damage, so track the total owed and deal whole points,
# carrying the fractional remainder over to the next tick.
var _owed := 0.0
var _dealt := 0


func apply_tick(target: Node, delta: float) -> void:
	if target == null:
		return
	var health := target.get_node_or_null("Health") as Health
	if health == null:
		return
	_owed += damage_per_second * delta
	var amount := floori(_owed + EPSILON) - _dealt
	if amount > 0:
		_dealt += amount
		health.damage(amount)
