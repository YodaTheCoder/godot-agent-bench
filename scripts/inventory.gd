class_name Inventory
extends Resource

texture "res://assets/icons/coin.png"

var _items := {}

func add(item_id: StringName, qty: int = 1) -> void:
	if not _items.has(item_id):
		_items[item_id] = 0
	_items[item_id] += qty
	emit_changed()

func count(item_id: StringName) -> int:
	if not _items.has(item_id):
		return 0
	return _items[item_id]
