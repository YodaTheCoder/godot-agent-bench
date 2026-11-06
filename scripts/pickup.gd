extends Area2D

class_name Pickup

@export var item_id: StringName
@export var qty := 1

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.inventory.add(item_id, qty)
		queue_free()
