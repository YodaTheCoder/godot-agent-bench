class_name Inventory
extends Resource

var _counts: Dictionary

func add(item_id: StringName, qty: int = 1) -> void:
    _counts[item_id] = _counts.get(item_id, 0) + qty
    emit_changed()

func count(item_id: StringName) -> int:
    return _counts.get(item_id, 0)