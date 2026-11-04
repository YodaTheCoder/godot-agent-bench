extends GodotTestCase

func test_inventory_basic():
	var inventory = Inventory.new()
	
	# Test initial count is 0 for any item
	assert_eq(inventory.count(&"coin"), 0)
	
	# Test adding items
	inventory.add(&"coin")
	assert_eq(inventory.count(&"coin"), 1)
	
	# Test adding multiple items
	inventory.add(&"coin", 4)
	assert_eq(inventory.count(&"coin"), 5)
	
	# Test that different items are independent
	inventory.add(&"gem")
	assert_eq(inventory.count(&"gem"), 1)
	assert_eq(inventory.count(&"coin"), 5) # Should still be 5
	
	print("All inventory tests passed!")

func test_player_inventory():
	var player = preload("res://scenes/player.tscn").instantiate()
	assert_is_instance_of(player, Player)
	assert_is_instance_of(player.inventory, Inventory)
	assert_eq(player.inventory.count(&"any_item"), 0)
	
	print("Player inventory test passed!")

func test_pickup_functionality():
	# Create a test player
	var player = preload("res://scenes/player.tscn").instantiate()
	
	# Create a pickup
	var pickup_scene = preload("res://scenes/pickup.tscn")
	var pickup = pickup_scene.instantiate()
	pickup.item_id = &"gem"
	pickup.qty = 3
	
	# Test pickup functionality manually (simulate body_entered)
	pickup._on_body_entered(player)
	
	# Check that player received the items
	assert_eq(player.inventory.count(&"gem"), 3)
	assert_true(pickup.is_queued_for_deletion())
	
	print("Pickup functionality test passed!")

func test_pickup_with_non_player():
	# Create a test player
	var player = preload("res://scenes/player.tscn").instantiate()
	
	# Create a pickup
	var pickup_scene = preload("res://scenes/pickup.tscn")
	var pickup = pickup_scene.instantiate()
	pickup.item_id = &"gem"
	pickup.qty = 3
	
	# Test with a non-player node (StaticBody2D)
	var static_body = StaticBody2D.new()
	
	# Manually call the body_entered function
	pickup._on_body_entered(static_body)
	
	# Check that pickup is NOT deleted and player inventory is unchanged
	assert_false(pickup.is_queued_for_deletion())
	assert_eq(player.inventory.count(&"gem"), 0) # Should still be 0
	
	print("Pickup with non-player test passed!")

func test_multiple_adds_emit_signals():
	var inventory = Inventory.new()
	var signal_emitted = false
	
	# Connect to the changed signal
	inventory.connect("changed", func(): signal_emitted = true)
	
	# Add an item - should emit signal once
	inventory.add(&"coin")
	assert_true(signal_emitted)
	signal_emitted = false
	
	# Add again - should emit signal again
	inventory.add(&"coin", 2)
	assert_true(signal_emitted)
	
	print("Signal emission test passed!")
