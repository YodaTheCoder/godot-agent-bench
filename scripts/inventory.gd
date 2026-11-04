class_name Inventory
extends Resource

# Dictionary to store item counts
var items := {}

func add(item_id: StringName, qty: int = 1) -> void:
	# If item doesn't exist, initialize it with 0
	if not items.has(item_id):
		items[item_id] = 0
	# Add the quantity
	items[item_id] += qty
	# Emit changed signal (Resource already has this signal)
	emit_changed()

func count(item_id: StringName) -> int:
	return items.get(item_id, 0)
