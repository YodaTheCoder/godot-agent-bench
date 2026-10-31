class_name StatusEffect
extends Resource

## How long the effect lasts once added to a StatusEffects component, in seconds.
@export var duration := 1.0


## Applies the effect to `target` for `delta` seconds. Does nothing in the base class.
func apply_tick(_target: Node, _delta: float) -> void:
	pass
