extends Node

func test_inventory_basic() -> void:
	var inventory := Inventory.new()
	
	# Test initial count is 0 for any item
	assert(inventory.count(&"coin") == 0)
	
	# Test adding items
	inventory.add(&"coin")
	inventory.add(&"coin", 4)
	
	# Test count after additions
	assert(inventory.count(&"coin") == 5)
	assert(inventory.count(&"gem") == 0)  # Ensure independent counts
	
	print("Inventory test passed!")

func test_inventory_signal() -> void:
	var inventory := Inventory.new()
	var signal_emitted := false
	
	# Connect to the changed signal
	inventory.connect("changed", func():
		signal_emitted = true
	)
	
	# Add an item and check signal was emitted
	inventory.add(&"coin")
	assert(signal_emitted == true)
	
	print("Inventory signal test passed!")

func _ready() -> void:
	test_inventory_basic()
	test_inventory_signal()