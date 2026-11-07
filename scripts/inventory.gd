class_name Inventory
extends Resource

var _items: Dictionary = {}

func add(item_id: StringName, qty: int = 1) -> void:
	_items[item_id] = _items.get(item_id, 0) + qty
	emit_changed()

func count(item_id: StringName) -> int:
	return _items.get(item_id, 0)