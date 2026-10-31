class_name Inventory
extends Resource

## Item counts keyed by item id.
var _counts: Dictionary[StringName, int] = {}


func add(item_id: StringName, qty: int = 1) -> void:
	_counts[item_id] = count(item_id) + qty
	emit_changed()


func count(item_id: StringName) -> int:
	return _counts.get(item_id, 0)
