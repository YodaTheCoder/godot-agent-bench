extends GutTest


func test_inventory_count_returns_zero_for_unadded_item() -> void:
	var inv := Inventory.new()
	assert_eq(inv.count(&"coin"), 0)


func test_inventory_add_accumulates_counts() -> void:
	var inv := Inventory.new()
	inv.add(&"coin")
	inv.add(&"coin", 4)
	assert_eq(inv.count(&"coin"), 5)
	assert_eq(inv.count(&"gem"), 0)


func test_inventory_add_emits_changed_signal_once_per_call() -> void:
	var inv := Inventory.new()
	watch_signals(inv)
	inv.add(&"coin")
	assert_signal_emit_count(inv, "changed", 1)
	inv.add(&"gem", 2)
	assert_signal_emit_count(inv, "changed", 2)


func test_player_has_inventory_from_scene() -> void:
	var player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	assert_is(player.inventory, Inventory)
	assert_eq(player.inventory.count(&"anything"), 0)


func test_pickup_scene_exists() -> void:
	var scene := load("res://scenes/pickup.tscn")
	assert_not_null(scene)