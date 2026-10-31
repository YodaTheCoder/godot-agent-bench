extends GutTest


func test_unknown_item_counts_zero() -> void:
	assert_eq(Inventory.new().count(&"coin"), 0)


func test_add_accumulates_per_item() -> void:
	var inventory := Inventory.new()
	inventory.add(&"coin")
	inventory.add(&"coin", 4)
	assert_eq(inventory.count(&"coin"), 5)
	assert_eq(inventory.count(&"gem"), 0)


func test_each_add_emits_changed_once() -> void:
	var inventory := Inventory.new()
	watch_signals(inventory)
	inventory.add(&"coin")
	inventory.add(&"gem", 2)
	assert_signal_emit_count(inventory, "changed", 2)


func test_player_starts_with_own_empty_inventory() -> void:
	var scene := load("res://scenes/player.tscn")
	var a: Player = add_child_autofree(scene.instantiate())
	var b: Player = add_child_autofree(scene.instantiate())
	assert_is(a.inventory, Inventory)
	assert_eq(a.inventory.count(&"coin"), 0)
	assert_ne(a.inventory, b.inventory)
