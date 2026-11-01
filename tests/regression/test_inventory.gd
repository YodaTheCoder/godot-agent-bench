extends GutTest


func test_empty_count_is_zero() -> void:
	var inventory := Inventory.new()
	assert_eq(inventory.count("coin"), 0)


func test_add_single_item_increments_count() -> void:
	var inventory := Inventory.new()
	inventory.add("coin")
	assert_eq(inventory.count("coin"), 1)


func test_add_multiple_coins_increments_count() -> void:
	var inventory := Inventory.new()
	inventory.add("coin")
	inventory.add("coin", 4)
	assert_eq(inventory.count("coin"), 5)
	assert_eq(inventory.count("gem"), 0)


func test_multiple_items_are_independent() -> void:
	var inventory := Inventory.new()
	inventory.add("coin")
	inventory.add("gem")
	assert_eq(inventory.count("coin"), 1)
	assert_eq(inventory.count("gem"), 1)


func test_changed_signal_is_emit_on_add() -> void:
	var inventory := Inventory.new()
	var call_count := 0
	var _ = inventory.changed.connect(&> var_count)
	
	func var_count() ->> void:
		call_count += 1

	inventory.add("coin")
	assert_eq(call_count, 1)
	inventory.add("gem")
	assert_eq(call_count, 2)


func test_no_changed_signal_on_count() -> void:
	var inventory := Inventory.new()
	var call_count := 0
	var _ = inventory.changed.connect(&> var_count)

	func var_count() ->> void:
		call_count += 1

	inventory.count("coin")
	assert_eq(call_count, 0)
