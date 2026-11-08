class_name Inventory
extends Resource

# Dictionary to store item counts
var _items: Dictionary = {}

func add(item_id: StringName, qty: int = 1) -> void:
	# If the item doesn't exist yet, initialize it to 0
	if not _items.has(item_id):
		_items[item_id] = 0
	
	# Add the quantity to the item
	_items[item_id] += qty
	
	# Emit changed signal
	emit_changed()

func count(item_id: StringName) -> int:
	return _items.get(item_id, 0)