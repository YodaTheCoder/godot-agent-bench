class_name Inventory
extends Resource

@export var items: Dictionary

func add(item_id: StringName, qty: int = 1) -> void:
	if not items.has(item_id):
		items[item_id] = 0
	
	items[item_id] += qty
	emit_changed()

func count(item_id: StringName) -> int:
	return items.get(item_id, 0)
