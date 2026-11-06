extends "res://tests/regression/test_base.gd"

func test_inventory():
	var inventory = Inventory.new()
	
	# Test initial state
	assert_eq(inventory.count(&"coin"), 0)
	
	# Test adding items 
	inventory.add(&"coin")
	assert_eq(inventory.count(&"coin"), 1)
	
	inventory.add(&"coin", 4)
	assert_eq(inventory.count(&"coin"), 5)
	
	# Test different items don't interfere
	inventory.add(&"gem")
	assert_eq(inventory.count(&"gem"), 1)
	assert_eq(inventory.count(&"coin"), 5)  # Should still be 5
	
	# Test that no items are added for invalid item_id
	assert_eq(inventory.count(&"nonexistent"), 0)

func test_player_inventory():
	var player = preload("res://scenes/player.tscn").instantiate()
	assert_not_null(player.inventory)
	assert_eq(player.inventory.count(&"any_item"), 0)
	player.queue_free()

func test_pickup_functionality():
	var pickup_scene = preload("res://scenes/pickup.tscn")
	var pickup = pickup_scene.instantiate()
	pickup.item_id = &"gem"
	pickup.qty = 3
	
	var player = preload("res://scenes/player.tscn").instantiate()
	
	# Test that pickup adds items to inventory and destroys itself
	pickup._on_body_entered(player)
	assert_eq(player.inventory.count(&"gem"), 3)
	assert_true(pickup.is_queued_for_deletion())
	
	player.queue_free()
	pickup.queue_free()