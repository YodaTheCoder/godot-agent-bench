extends GutTest


func _make_player() -> Player:
	return add_child_autofree(load("res://scenes/player.tscn").instantiate())


func _make_pickup(item: StringName, amount: int) -> Area2D:
	var pickup: Area2D = load("res://scenes/pickup.tscn").instantiate()
	pickup.set("item_id", item)
	pickup.set("qty", amount)
	add_child_autofree(pickup)
	return pickup


func test_add_and_count() -> void:
	var inventory := Inventory.new()
	assert_eq(inventory.count(&"coin"), 0, "never-added item counts 0")
	inventory.add(&"coin")
	inventory.add(&"coin", 4)
	assert_eq(inventory.count(&"coin"), 5)
	assert_eq(inventory.count(&"gem"), 0, "other items unaffected")


func test_add_emits_changed_each_time() -> void:
	var inventory := Inventory.new()
	watch_signals(inventory)
	inventory.add(&"coin")
	inventory.add(&"gem", 2)
	assert_signal_emit_count(inventory, "changed", 2)


func test_player_starts_with_empty_inventory() -> void:
	var player := _make_player()
	assert_is(player.inventory, Inventory)
	assert_eq(player.inventory.count(&"gem"), 0)


func test_pickup_adds_items_and_frees_itself() -> void:
	var player := _make_player()
	var pickup := _make_pickup(&"gem", 3)
	pickup.call("_on_body_entered", player)
	assert_eq(player.inventory.count(&"gem"), 3)
	assert_true(pickup.is_queued_for_deletion())


func test_body_entered_signal_is_connected() -> void:
	var player := _make_player()
	var pickup := _make_pickup(&"coin", 2)
	pickup.body_entered.emit(player)
	assert_eq(player.inventory.count(&"coin"), 2)
	assert_true(pickup.is_queued_for_deletion())


func test_pickup_ignores_non_player_bodies() -> void:
	var pickup := _make_pickup(&"gem", 1)
	var wall: StaticBody2D = add_child_autofree(StaticBody2D.new())
	pickup.call("_on_body_entered", wall)
	assert_false(pickup.is_queued_for_deletion())
