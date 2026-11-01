extends "res://tests/regression/test_player.gd"

func test_pickup() -> void:
	var player_scene := preload("res://scenes/player.tscn")
	var player = player_scene.instantiate()
	
	# Test that player has inventory
	assert(player.inventory != null)
	assert(player.inventory.count(&"gem") == 0)
	
	# Create pickup
	var pickup_scene := preload("res://scenes/pickup.tscn")
	var pickup = pickup_scene.instantiate()
	pickup.item_id = &"gem"
	pickup.qty = 3
	
	# Test pickup behavior with player
	pickup._on_body_entered(player)
	
	# Test that item was added to inventory
	assert(player.inventory.count(&"gem") == 3)
	
	# Test that pickup was removed
	assert(pickup.is_queued_for_deletion())
	
	print("Pickup tests passed!")