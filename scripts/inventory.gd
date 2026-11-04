class_name Inventory
extends Resource

var items := {}

func add(item_id: StringName, qty: int = 1) -> void:
	items[item_id] = items.get(item_id, 0) + qty
	emit_changed()

func count(item_id: StringName) -> int:
	return items.get(item_id, 0)
