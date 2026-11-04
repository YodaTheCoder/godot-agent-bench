class_name Inventory
extends Resource

# Dictionary to store item counts
var _items: Dictionary = {}

# Adds qty to the count for item_id
func add(item_id: StringName, qty: int = 1) -> void:
	_items[item_id] = _items.get(item_id, 0) + qty
	emit_changed()

# Returns the current count for item_id; 0 for an item that was never added
func count(item_id: StringName) -> int:
	return _items.get(item_id, 0)
