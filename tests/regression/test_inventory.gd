# Test for inventory implementation
extends GutTest

func test_inventory_basic():
	var inv = Inventory.new()
	
	# Test initial count is 0
	assert_eq(inv.count(&"coin"), 0)
	
	# Test adding items
	inv.add(&"coin")
	assert_eq(inv.count(&"coin"), 1)
	
	inv.add(&"coin", 4)
	assert_eq(inv.count(&"coin"), 5)
	
	# Test that different items don't interfere
	inv.add(&"gem")
	assert_eq(inv.count(&"gem"), 1)
	assert_eq(inv.count(&"coin"), 5)

func test_player_inventory():
	var player = preload("res://scenes/player.tscn").instantiate()
	assert_not_null(player.inventory)
	assert_eq(player.inventory.count(&"any_item"), 0)
	
	# Clean up
	player.queue_free()

func test_pickup_functionality():
	var pickup = preload("res://scenes/pickup.tscn").instantiate()
	pickup.item_id = &"gem"
	pickup.qty = 3
	
	var player = preload("res://scenes/player.tscn").instantiate()
	
	# Test pickup with player
	pickup._on_body_entered(player)
	assert_eq(player.inventory.count(&"gem"), 3)
	assert_true(pickup.is_queued_for_deletion())
	
	# Clean up
	player.queue_free()
	pickup.queue_free()