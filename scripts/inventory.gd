class_name Inventory
extends Resource

var _counts := {}

func add(item_id: StringName, qty: int = 1) -> void:
    if item_id not in _counts:
        _counts[item_id] = 0
    _counts[item_id] += qty
    emit_changed()


func count(item_id: StringName) -> int:
    return _counts.get(item_id, 0)
