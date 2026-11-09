extends Node

func _ready() -> void:
	# Test Inventory functionality
	var inventory := Inventory.new()
	
	# Test initial count
	assert(inventory.count(&"coin") == 0)
	print("✓ Initial count test passed")
	
	# Test adding items
	inventory.add(&"coin")
	inventory.add(&"coin", 4)
	
	# Test final count
	assert(inventory.count(&"coin") == 5)
	assert(inventory.count(&"gem") == 0)
	print("✓ Add and count tests passed")
	
	# Test player inventory creation
	var player := preload("res://scenes/player.tscn").instantiate()
	assert(player.inventory is Inventory)
	assert(player.inventory.count(&"any_item") == 0)
	print("✓ Player inventory test passed")
	
	print("All tests passed!")