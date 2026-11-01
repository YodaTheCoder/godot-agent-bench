extends "res://tests/regression/test_player.gd"

func test_inventory() -> void:
	var inventory := Inventory.new()
	
	# Test initial state
	assert(inventory.count(&"coin") == 0)
	
	# Test adding items
	inventory.add(&"coin")
	inventory.add(&"coin", 4)
	
	# Test count
	assert(inventory.count(&"coin") == 5)
	assert(inventory.count(&"gem") == 0)
	
	# Test that different items are independent
	inventory.add(&"gem", 2)
	assert(inventory.count(&"coin") == 5)
	assert(inventory.count(&"gem") == 2)
	
	print("Inventory tests passed!")