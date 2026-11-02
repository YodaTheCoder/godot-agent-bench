class_name Poison

extends StatusEffect

@export var damage_per_second : float = 5.0

var _damage_owed : float = 0.0

func apply_tick(target: Node, delta: float) -> void:
    var child : Node = target.get_node_or_null("Health")
    if child == null:
        return
    # Accumulate damage
    _damage_owed += damage_per_second * delta
    var damage_int : int = int(floor(_damage_owed))
    if damage_int > 0:
        # Assuming child has damage(amount:int)
        child.damage(damage_int)
        _damage_owed -= damage_int
