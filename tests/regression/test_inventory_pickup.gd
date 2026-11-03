extends GutTest

func test_inventory_basics() -> void:
	var inv = Inventory.new()
	assert_eq(inv.count(&"coin"), 0, "Initial count should be 0")
	
	inv.add(&"coin")
	assert_eq(inv.count(&"coin"), 1, "Count after adding 1 coin should be 1")
	inv.add(&"coin", 4)
	assert_eq(inv.count(&"coin"), 5, "Count after adding 4 more should be 5")
	assert_eq(inv.count(&"gem"), 0, "Gem count should still be 0")

func test_inventory_signals() -> void:
	var inv = Inventory.new()
	var change_count = 0
	inv.changed.connect(func(): change_count += 1)
	
	inv.add(&"coin")
	assert_eq(change_count, 1, "First add should emit changed once")
	
	inv.add(&"coin", 4)
	assert_eq(change_count, 2, "Second add should emit changed again")

func test_player_inventory_initialization() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	assert_not_null(player.inventory, "Player must have an inventory")
	assert_is(player.inventory, Inventory, "Player inventory must be an Inventory resource")
	assert_eq(player.inventory.count(&"coin"), 0, "Player inventory should be empty")

func test_pickup_functionality() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var pickup_scene = load("res://scenes/pickup.tscn")
	var pickup = pickup_scene.instantiate()
	add_child(pickup)
	
	pickup.item_id = &"gem"
	pickup.qty = 3
	
	# Manually trigger the function to simulate body_entered
	pickup._on_body_entered(player)
	
	assert_eq(player.inventory.count(&"gem"), 3, "Player should have collected 3 gems")
	assert_true(pickup.is_queued_for_deletion(), "Pickup should be queued for deletion")

func test_pickup_ignores_non_player() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var static_body = StaticBody2D.new()
	add_child(static_body)
	
	var pickup_scene = load("res://scenes/pickup.tscn")
	var pickup = pickup_scene.instantiate()
	add_child(pickup)
	
	pickup.item_id = &"gem"
	pickup.qty = 3
	
	pickup._on_body_entered(static_body)
	
	assert_eq(player.inventory.count(&"gem"), 0, "Player should not receive gems from non-player collision")
	assert_false(pickup.is_queued_for_deletion(), "Pickup should not be deleted on non-player collision")
	
	static_body.free()
