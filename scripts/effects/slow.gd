extends StatusEffect

@export var multiplier := 0.5

func apply_tick(target: Node, delta: float) -> void:
	# This effect doesn't do anything in apply_tick, it's handled in Player
	pass