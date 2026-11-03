extends GutTest

func test_inventory_new_count_is_zero() -> void:
	assert_eq(Inventory.new().count(&"coin"), 0)

func test_inventory_add_increment() -> void:
	var inv := Inventory.new()
	inv.add(&"coin")
	inv.add(&"coin", 4)
	assert_eq(inv.count(&"coin"), 5)
	assert_eq(inv.count(&"gem"), 0)

func test_inventory_emits_changed_once_per_add() -> void:
	var inv := Inventory.new()
	var change_count := 0
	inv.changed.connect(func() -> void: change_count += 1)
	inv.add(&"coin")
	inv.add(&"gem", 3)
	assert_eq(change_count, 2)

func test_player_has_inventory() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	assert_not_null(player.inventory)
	assert_is(player.inventory, Inventory)
	assert_eq(player.inventory.count(&"coin"), 0)

func test_pickup_collects_for_player() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var pickup: Pickup = add_child_autofree(load("res://scenes/pickup.tscn").instantiate())
	pickup.item_id = &"gem"
	pickup.qty = 3
	pickup._on_body_entered(player)
	assert_eq(player.inventory.count(&"gem"), 3)
	assert_true(pickup.is_queued_for_deletion())

func test_pickup_body_entered_signal() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var pickup: Pickup = add_child_autofree(load("res://scenes/pickup.tscn").instantiate())
	pickup.item_id = &"ruby"
	pickup.qty = 7
	pickup.body_entered.emit(player)
	assert_eq(player.inventory.count(&"ruby"), 7)
	assert_true(pickup.is_queued_for_deletion())

func test_pickup_does_not_collect_non_player() -> void:
	var pickup: Pickup = add_child_autofree(load("res://scenes/pickup.tscn").instantiate())
	pickup.item_id = &"gem"
	pickup.qty = 3
	var static_body := StaticBody2D.new()
	pickup._on_body_entered(static_body)
	assert_false(pickup.is_queued_for_deletion())
