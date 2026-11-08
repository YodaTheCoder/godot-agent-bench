extends Node

func _ready() -> void:
	var inventory = Inventory.new()
	
	# Test initial state
	assert(inventory.count(&"coin") == 0)
	print("✓ Initial count test passed")
	
	# Test adding items
	inventory.add(&"coin")
	inventory.add(&"coin", 4)
	
	# Test final count
	assert(inventory.count(&"coin") == 5)
	print("✓ Add items test passed")
	
	# Test that different items are independent
	inventory.add(&"gem")
	assert(inventory.count(&"gem") == 1)
	assert(inventory.count(&"coin") == 5)  # Should still be 5
	print("✓ Independent items test passed")
	
	print("All inventory tests passed!")