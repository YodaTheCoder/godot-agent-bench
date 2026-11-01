class_name Inventory
extends Resource

var _counts = {}  # Dictionary of StringName -> int

func add(item_id: StringName, qty: int = 1) -> void:
	if not _counts.has(item_id):
		_counts[item_id] = 0
	_counts[item_id] += qty
	emit_changed()

func count(item_id: StringName) -> int:
	if _counts.has(item_id):
		return _counts[item_id]
	return 0
