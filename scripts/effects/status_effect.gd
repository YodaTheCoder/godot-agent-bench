class_name StatusEffect
extends Resource

## How long the effect lasts, in seconds.
@export var duration := 1.0


## Applies `delta` seconds of this effect to `target`. The base effect does nothing.
func apply_tick(_target: Node, _delta: float) -> void:
	pass
