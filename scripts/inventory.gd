class_name Inventory
extends Resource

var _items: Dictionary = {}

func add(item_id: StringName, qty: int = 1) -> void:
	if not _items.has(item_id):
		_items[item_id] = 0
	_items[item_id] += qty
	emit_changed()

func count(item_id: StringName) -> int:
	return _items.get(item_id, 0)
