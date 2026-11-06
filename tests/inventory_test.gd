# Test for inventory system implementation
extends GUTTest

func test_inventory_initialization():
	var inv := Inventory.new()
	assert_eq(inv.count(&"coin"), 0)

func test_inventory_add_and_count():
	var inv := Inventory.new()
	
	inv.add(&"coin")
	inv.add(&"coin", 4)
	
	assert_eq(inv.count(&"coin"), 5)
	assert_eq(inv.count(&"gem"), 0)

func test_inventory_signal_emission():
	var inv := Inventory.new()
	var call_count = 0
	
	inv.connect("changed", func(): call_count += 1)
	
	inv.add(&"coin")
	inv.add(&"coin", 4)
	
	assert_eq(call_count, 2)

func test_player_inventory_creation():
	var player := preload("res://scenes/player.tscn").instantiate()
	assert_true(player.inventory != null)
	assert_eq(player.inventory.count(&"coin"), 0)

func test_pickup_functionality():
	var pickup = preload("res://scenes/pickup.tscn").instantiate()
	pickup.item_id = &"gem"
	pickup.qty = 3
	
	var player := preload("res://scenes/player.tscn").instantiate()
	
	# Simulate body entered
	pickup._on_body_entered(player)
	
	assert_eq(player.inventory.count(&"gem"), 3)
	assert_true(pickup.is_queued_for_deletion())

func test_pickup_with_non_player_body():
	var pickup = preload("res://scenes/pickup.tscn").instantiate()
	pickup.item_id = &"gem"
	pickup.qty = 3
	
	var static_body := StaticBody2D.new()
	
	# Simulate body entered with a non-player
	pickup._on_body_entered(static_body)
	
	assert_false(pickup.is_queued_for_deletion())