extends Node

func _ready() -> void:
	# Test Inventory functionality
	var inventory := Inventory.new()
	
	# Test initial count is 0
	assert(inventory.count(&"coin") == 0)
	
	# Test adding items
	inventory.add(&"coin")
	inventory.add(&"coin", 4)
	
	# Test count after additions
	assert(inventory.count(&"coin") == 5)
	assert(inventory.count(&"gem") == 0)
	
	# Test that different items don't interfere
	inventory.add(&"gem", 3)
	assert(inventory.count(&"gem") == 3)
	assert(inventory.count(&"coin") == 5)
	
	print("All inventory tests passed!")
	
	# Test Player inventory
	var player := preload("res://scenes/player.tscn").instantiate()
	assert(player.inventory is Inventory)
	assert(player.inventory.count(&"gem") == 0)
	
	# Test Pickup functionality
	var pickup := preload("res://scenes/pickup.tscn").instantiate()
	pickup.item_id = &"gem"
	pickup.qty = 3
	
	# Simulate pickup being collected by player
	pickup._on_body_entered(player)
	
	assert(player.inventory.count(&"gem") == 3)
	assert(pickup.is_queued_for_deletion())
	
	print("All pickup tests passed!")