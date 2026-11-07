extends Node

func _ready() -> void:
	# Test Inventory functionality
	var inventory := Inventory.new()
	
	# Test initial count
	assert(inventory.count(&"coin") == 0)
	
	# Test adding items
	inventory.add(&"coin")
	inventory.add(&"coin", 4)
	
	# Test final count
	assert(inventory.count(&"coin") == 5)
	assert(inventory.count(&"gem") == 0)
	
	print("All inventory tests passed!")