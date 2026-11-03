extends GutTest

func test_inventory_basic_operations() -> void:
	var inventory = Inventory.new()
	assert_eq(inventory.count(&"coin"), 0, "Initial count should be 0")
	
	inventory.add(&"coin")
	assert_eq(inventory.count(&"coin"), 1, "Count after first add should be 1")
	assert_eq(inventory.count(&"gem"), 0, "Gem count should still be 0")
	
	inventory.add(&"coin", 4)
	assert_eq(inventory.count(&"coin"), 5, "Count after second add should be 5")

func test_inventory_signals() -> void:
	var inventory = Inventory.new()
	var signal_count = 0
	inventory.changed.connect(func(): signal_count += 1)
	
	inventory.add(&"coin")
	assert_eq(signal_count, 1, "Should emit changed once")
	
	inventory.add(&"coin", 4)
	assert_eq(signal_count, 2, "Should emit changed twice in total")

func test_player_inventory_initialization() -> void:
	var player_scene = load("res://scenes/player.tscn")
	var player = player_scene.instantiate()
	assert_not_null(player.inventory, "Player should have an inventory")
	assert_eq(player.inventory.count(&"coin"), 0, "Player inventory should be empty")
	player.free()

func test_pickup_logic_direct_call() -> void:
	var player_scene = load("res://scenes/player.tscn")
	var player = player_scene.instantiate()
	
	var pickup_scene = load("res://scenes/pickup.tscn")
	var pickup = pickup_scene.instantiate()
	pickup.item_id = &"gem"
	pickup.qty = 3
	
	# Test direct call
	pickup._on_body_entered(player)
	assert_eq(player.inventory.count(&"gem"), 3, "Player should have collected 3 gems")
	assert(pickup.is_queued_for_deletion(), "Pickup should be queued for deletion")
	
	player.free()

func test_pickup_logic_signal_emission() -> void:
	var player_scene = load("res://scenes/player.tscn")
	var player = player_scene.instantiate()
	
	var pickup_scene = load("res://scenes/pickup.tscn")
	var pickup = pickup_scene.instantiate()
	pickup.item_id = &"coin"
	pickup.qty = 1
	add_child(pickup)
	
	# Manually trigger the signal
	pickup.emit_signal("body_entered", player)
	
	assert_eq(player.inventory.count(&"coin"), 1, "Player should have collected 1 coin")
	assert(pickup.is_queued_for_deletion(), "Pickup should be queued for deletion")
	
	player.free()
	pickup.free()

func test_pickup_ignores_non_player() -> void:
	var player_scene = load("res://scenes/player.tscn")
	var player = player_scene.instantiate()
	
	# Create a dummy StaticBody2D
	var static_body = StaticBody2D.new()
	add_child(static_body)
	
	var pickup_scene = load("res://scenes/pickup.tscn")
	var pickup = pickup_scene.instantiate()
	pickup.item_id = &"coin"
	pickup.qty = 1
	add_child(pickup)
	
	pickup._on_body_entered(static_body)
	
	assert_eq(player.inventory.count(&"coin"), 0, "Player should not have collected anything")
	assert(!pickup.is_queued_for_deletion(), "Pickup should not be queued for deletion")
	
	player.free()
	static_body.free()
	pickup.free()
