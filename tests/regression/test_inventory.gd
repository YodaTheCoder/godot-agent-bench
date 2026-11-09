extends GutTest

func test_inventory_starts_empty() -> void:
	var inventory: Inventory = Inventory.new()
	assert_eq(inventory.count(&"coin"), 0)


func test_add_item() -> void:
	var inventory: Inventory = Inventory.new()
	inventory.add(&"coin")
	assert_eq(inventory.count(&"coin"), 1)


func test_add_multiple_items() -> void:
	var inventory: Inventory = Inventory.new()
	inventory.add(&"coin")
	inventory.add(&"coin", 4)
	assert_eq(inventory.count(&"coin"), 5)


func test_different_items_are_independent() -> void:
	var inventory: Inventory = Inventory.new()
	inventory.add(&"coin")
	inventory.add(&"coin", 4)
	inventory.add(&"gem")
	assert_eq(inventory.count(&"coin"), 5)
	assert_eq(inventory.count(&"gem"), 1)


func test_inventory_signal_emitted() -> void:
	var inventory: Inventory = Inventory.new()
	var signal_emitted := false
	inventory.connect("changed", func(): signal_emitted = true)
	inventory.add(&"coin")
	assert_true(signal_emitted)


func test_player_has_inventory() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	assert_is(player.inventory, Inventory)
	assert_eq(player.inventory.count(&"any_item"), 0)


func test_pickup_adds_to_inventory() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var pickup: Pickup = add_child_autofree(load("res://scenes/pickup.tscn").instantiate())
	pickup.item_id = &"gem"
	pickup.qty = 3
	pickup._on_body_entered(player)
	assert_eq(player.inventory.count(&"gem"), 3)
	assert_true(pickup.is_queued_for_deletion())


func test_pickup_not_deleted_for_non_player() -> void:
	var pickup: Pickup = add_child_autofree(load("res://scenes/pickup.tscn").instantiate())
	pickup.item_id = &"gem"
	pickup.qty = 3
	var static_body: StaticBody2D = add_child_autofree(StaticBody2D.new())
	pickup._on_body_entered(static_body)
	assert_false(pickup.is_queued_for_deletion())