extends "res://tests/regression/test_player.gd"

func test_pickup_functionality() -> void:
	# Test that pickup adds items correctly to player inventory
	var player := preload("res://scenes/player.tscn").instantiate()
	var pickup_scene = preload("res://scenes/pickup.tscn")
	var pickup := pickup_scene.instantiate()
	pickup.item_id = &"gem"
	pickup.qty = 3
	
	# Simulate the body_entered signal
	pickup._on_body_entered(player)
	
	assert(player.inventory.count(&"gem") == 3)
	assert(pickup.is_queued_for_deletion() == true)
	
	player.queue_free()
	pickup.queue_free()

func test_pickup_with_non_player_body() -> void:
	# Test that pickup doesn't get deleted when non-player body enters
	var player := preload("res://scenes/player.tscn").instantiate()
	var pickup_scene = preload("res://scenes/pickup.tscn")
	var pickup := pickup_scene.instantiate()
	pickup.item_id = &"gem"
	pickup.qty = 3
	
	# Create a static body (not a player)
	var static_body := StaticBody2D.new()
	
	# Simulate the body_entered signal with non-player body
	pickup._on_body_entered(static_body)
	
	# Pickup should not be deleted and inventory should not be affected
	assert(player.inventory.count(&"gem") == 0)
	assert(pickup.is_queued_for_deletion() == false)
	
	player.queue_free()
	pickup.queue_free()
	static_body.queue_free()