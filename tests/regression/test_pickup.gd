extends "res://tests/regression/test_player.gd"

func test_pickup_functionality() -> void:
	var player = preload("res://scenes/player.tscn").instantiate()
	var pickup = preload("res://scenes/pickup.tscn").instantiate()
	pickup.item_id = &"gem"
	pickup.qty = 3
	
	# Simulate the body_entered signal
	pickup._on_body_entered(player)
	
	assert_eq(player.inventory.count(&"gem"), 3)
	assert_true(pickup.is_queued_for_deletion())