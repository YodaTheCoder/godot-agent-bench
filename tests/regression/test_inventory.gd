extends GutTest

var inventory: Inventory
func before_each() -> void:
	inventory = Inventory.new()
func test_new_inventory_initial_count_is_zero() -> void:
	assert_eq(inventory.count(&"coin"), 0)
func test_add_increases_count() -> void:
	inventory.add(&"coin")
	assert_eq(inventory.count(&"coin"), 1)
func test_add_with_quantity_increases_count() -> void:
	inventory.add(&"gem", 4)
	assert_eq(inventory.count(&"gem"), 4)
func test_add_to_multiple_items_independent() -> void:
	inventory.add(&"coin")
	inventory.add(&"gem")
	assert_eq(inventory.count(&"coin"), 1)
	assert_eq(inventory.count(&"gem"), 1)
func test_changed_signal_emitted_after_add() -> void:
	watch_signals(inventory)
	inventory.add(&"coin")
	assert_signal_emitted(inventory, "changed")
func test_changed_signal_emitted_after_multiple_adds() -> void:
	watch_signals(inventory)
	inventory.add(&"coin")
	inventory.add(&"gem")
	assert_signal_emitted(inventory, "changed", 2)