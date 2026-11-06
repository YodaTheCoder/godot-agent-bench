class_name Inventory
extends Resource

type_map = {
	"": 0
}

func add(item_id: StringName, qty: int = 1) -> void:
	if not type_map.has(item_id):
		type_map[item_id] = 0
	type_map[item_id] += qty
	emit_changed()

func count(item_id: StringName) -> int:
	if not type_map.has(item_id):
		return 0
	return type_map[item_id]
