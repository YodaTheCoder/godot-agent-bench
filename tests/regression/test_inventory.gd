extends GutTest


func test_inventory_starts_empty() -> void:
	var inv = Inventory.new()
	assert_eq(inv.count(&"coin"), 0)


func test_add_single_item() -> void:
	var inv = Inventory.new()
	inv.add(&"coin")
	assert_eq(inv.count(&"coin"), 1)


func test_add_multiple_of_same_item() -> void:
	var inv = Inventory.new()
	inv.add(&"coin")
	inv.add(&"coin", 4)
	assert_eq(inv.count(&"coin"), 5)


func test_add_different_items() -> void:
	var inv = Inventory.new()
	inv.add(&"coin")
	inv.add(&"coin", 4)
	assert_eq(inv.count(&"coin"), 5)
	assert_eq(inv.count(&"gem"), 0)


func test_add_emits_changed_once() -> void:
	var inv = Inventory.new()
	watch_signals(inv)
	inv.add(&"coin")
	assert_signal_emitted(inv, "changed")
	assert_eq(get_signal_emit_count(inv, "changed"), 1)


func test_player_has_inventory() -> void:
	var player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	assert_is(player.inventory, Inventory)
	assert_eq(player.inventory.count(&"coin"), 0)


func test_pickup_adds_to_inventory() -> void:
	var player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var pickup = add_child_autofree(load("res://scenes/pickup.tscn").instantiate())
	pickup.item_id = &"gem"
	pickup.qty = 3
	
	assert_eq(player.inventory.count(&"gem"), 0)
	pickup._on_body_entered(player)
	assert_eq(player.inventory.count(&"gem"), 3)
	assert_true(pickup.is_queued_for_deletion())


func test_pickup_body_entered_signal() -> void:
	var player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var pickup = add_child_autofree(load("res://scenes/pickup.tscn").instantiate())
	pickup.item_id = &"ruby"
	pickup.qty = 2
	
	# Manually emit the body_entered signal with player as argument
	pickup.body_entered.emit(player)
	
	assert_eq(player.inventory.count(&"ruby"), 2)
	assert_true(pickup.is_queued_for_deletion())


func test_pickup_non_player_does_nothing() -> void:
	var player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var pickup = add_child_autofree(load("res://scenes/pickup.tscn").instantiate())
	pickup.item_id = &"diamond"
	pickup.qty = 5
	
	var static_body = StaticBody2D.new()
	add_child_autofree(static_body)
	
	pickup._on_body_entered(static_body)
	
	assert_false(pickup.is_queued_for_deletion())
	assert_eq(player.inventory.count(&"diamond"), 0)
