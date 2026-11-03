extends GutTest


func test_inventory_counts_start_at_zero() -> void:
	var inventory: Inventory = Inventory.new()
	assert_eq(inventory.count(&"coin"), 0)
	assert_eq(inventory.count(&"gem"), 0)


func test_inventory_add_increments_count() -> void:
	var inventory: Inventory = Inventory.new()
	inventory.add(&"coin")
	assert_eq(inventory.count(&"coin"), 1)

	inventory.add(&"coin", 4)
	assert_eq(inventory.count(&"coin"), 5)

	# independent items
	assert_eq(inventory.count(&"gem"), 0)


func test_inventory_add_emits_changed_signal_once_per_call() -> void:
	var inventory: Inventory = Inventory.new()
	watch_signals(inventory)
	inventory.add(&"coin")
	assert_signal_emitted(inventory, "changed")

	# reset watch
	clear_watched_signals()
	watch_signals(inventory)
	inventory.add(&"coin", 3)
	assert_signal_emitted(inventory, "changed")

	# should not emit changed for independent item
	assert_signal_not_emitted(inventory, "changed")


func test_player_has_inventory() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	assert_is(player.inventory, Inventory)
	assert_eq(player.inventory.count(&"coin"), 0)

	# multiple items
	assert_eq(player.inventory.count(&"gem"), 0)


func test_pickup_adds_to_player_inventory() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var pickup: Pickup = add_child_autofree(load("res://scenes/pickup.tscn").instantiate())
	pickup.item_id = &"gem"
	pickup.qty = 3
	pickup._on_body_entered(player)

	assert_eq(player.inventory.count(&"gem"), 3)
	assert_true(pickup.is_queued_for_deletion())


func test_pickup_emits_body_entered_signal() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var pickup: Pickup = add_child_autofree(load("res://scenes/pickup.tscn").instantiate())
	pickup.item_id = &"gem"
	pickup.qty = 1
	assert_eq(player.inventory.count(&"gem"), 0)

	np(pickup._on_body_entered(player))

	assert_eq(player.inventory.count(&"gem"), 1)
	assert_true(pickup.is_queued_for_deletion())


func test_pickup_with_non_player_body() -> void:
	var pickup: Pickup = add_child_autofree(load("res://scenes/pickup.tscn").instantiate())
	pickup.item_id = &"gem"
	pickup.qty = 5
	
	var static_body = StaticBody2D.new()
	pickup._on_body_entered(static_body)

	assert_false(pickup.is_queued_for_deletion())
	assert_eq(pickup.count(&"gem"), 5)
	assert_eq(static_body.count(&"gem"), 0)