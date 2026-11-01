class_name Inventory
extends Resource

var counts: Dictionary = {}


func add(item_id: StringName, qty: int = 1) -> void:
	counts[item_id] = counts.get(item_id, 0) + qty
	emit_changed()


func count(item_id: StringName) -> int:
	return counts.get(item_id, 0)