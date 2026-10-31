extends Area2D

@export var item_id: StringName
@export var qty := 1


func _on_body_entered(body: Node2D) -> void:
	var player := body as Player
	if player == null:
		return
	player.inventory.add(item_id, qty)
	queue_free()
