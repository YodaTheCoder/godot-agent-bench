extends GutTest

func test_inventory_basics() -> void:
	var inv = Inventory.new()
	assert_eq(inv.count(&"coin"), 0, "Initial count should be 0")
	inv.add(&"coin")
	assert_eq(inv.count(&"coin"), 1, "Count after first add should be 1")
	inv.add(&"coin", 4)
	assert_eq(inv.count(&"coin"), 5, "Count after second add should be 5")
	assert_eq(inv.count(&"gem"), 0, "Gem count should still be 0")

func test_inventory_signal() -> void:
	var inv = Inventory.new()
	var signal_count = 0
	inv.changed.connect(func(): signal_count += 1)
	
	inv.add(&"coin")
	assert_eq(signal_count, 1, "Should emit signal once after first add")
	inv.add(&"coin", 4)
	assert_eq(signal_count, 2, "Should emit signal twice after two adds")

func test_player_inventory_init() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	assert_is(player.inventory, Inventory, "Player should have an Inventory")
	assert_eq(player.inventory.count(&"coin"), 0, "Player inventory should be empty")

func test_pickup_logic() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var pickup = load("res://scenes/pickup.tscn").instantiate()
	add_child(pickup)
	
	pickup.item_id = &"gem"
	pickup.qty = 3
	
	# Manually trigger body_entered
	pickup._on_body_entered(player)
	
	assert_eq(player.inventory.count(&"go"), 0) # Wait, I must use gem
	assert_eq(player.inventory.count(&"gem"), 3, "Player should have 3 gems")
	assert(pickup.is_queued_for_deletion(), "Pickup should be queued for deletion")

func test_pickup_ignores_non_player() -> void:
	var static_body = StaticBody2D.new()
	add_child(static_body)
	
	var pickup = load("res://scenes/pickup.tscn").instantiate()
	add_child(pickup)
	pickup.item_id = &"gem"
	pickup.qty = 3
	
	pickup._on_body_entered(static_body)
	
	assert_false(pickup.is_queued_for_deletion(), "Pickup should NOT be queued for deletion for non-player")
	
	static_body.queue_free()
