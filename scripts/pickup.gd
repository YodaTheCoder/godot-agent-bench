extends Area2D

@export var item_id: StringName
@export var qty: int = 1

func _ready():
	# Connect the body_entered signal to the handler (non-deferred)
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var p: Player = body as Player
		p.inventory.add(item_id, qty)
		queue_free()
