extends TestCase

func test_inventory_add_and_count():
	var inventory := Inventory.new()
	
	# Test initial count is 0
	assert_eq(inventory.count(&"coin"), 0)
	
	# Test adding one item
	inventory.add(&"coin")
	assert_eq(inventory.count(&"coin"), 1)
	
	# Test adding multiple items
	inventory.add(&"coin", 4)
	assert_eq(inventory.count(&"coin"), 5)
	
	# Test that different items don't interfere
	inventory.add(&"gem")
	assert_eq(inventory.count(&"gem"), 1)
	assert_eq(inventory.count(&"coin"), 5)

func test_inventory_signal_emitted():
	var inventory := Inventory.new()
	var signal_called := false
	
	inventory.connect("changed", func(): signal_called = true)
	
	inventory.add(&"coin")
	assert_true(signal_called)
	
	signal_called = false
	inventory.add(&"gem")
	assert_true(signal_called)