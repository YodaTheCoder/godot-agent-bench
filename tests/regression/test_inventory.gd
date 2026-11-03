extends GutTest

func test_inventory():
	var inv := Inventory.new()
	
	# Test initial count is 0
	assert_eq(inv.count(&"coin"), 0)
	
	# Test add functionality
	inv.add(&"coin")
	assert_eq(inv.count(&"coin"), 1)
	
	inv.add(&"coin", 4)
	assert_eq(inv.count(&"coin"), 5)
	
	# Test that different items are independent
	inv.add(&"gem")
	assert_eq(inv.count(&"gem"), 1)
	assert_eq(inv.count(&"coin"), 5)
	
	# Test count for non-existent item
	assert_eq(inv.count(&"nonexistent"), 0)

func test_inventory_signal_emitted():
	var inv := Inventory.new()
	var changed_count = 0
	
	func on_changed():
		changed_count += 1
	
	inv.connect("changed", Callable(self, "on_changed"))
	
	# Add twice, should emit signal twice
	inv.add(&"coin")
	inv.add(&"coin", 4)
	
	assert_eq(changed_count, 2)