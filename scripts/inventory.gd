class_name Inventory
extends Resource

var counts: Dictionary = {}

func add(item_id: StringName, qty: int = 1) -> void:
	if not counts.has(item_id):
		counts[item_id] = 0
	counts[item_id] += qty
	emit_changed()

func count(item_id: StringName) -> int:
	return counts.get(item_id, 0)