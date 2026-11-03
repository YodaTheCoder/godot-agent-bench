class_name Inventory
extends Resource

var items := {}

func add(item_id: StringName, qty: int = 1) -> void:
	if not items.has(item_id):
		items[item_id] = 0
	items[item_id] += qty
	emit_changed()

func count(item_id: StringName) -> int:
	if not items.has(item_id):
		return 0
	return items[item_id]