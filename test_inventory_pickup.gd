extends SceneTree

func _ready() -> void:
	# Test Inventory functionality
	var inventory := Inventory.new()
	
	# Test initial state
	assert(inventory.count(&"coin") == 0)
	
	# Test adding items
	inventory.add(&"coin")
	inventory.add(&"coin", 4)
	
	# Test counts
	assert(inventory.count(&"coin") == 5)
	assert(inventory.count(&"gem") == 0)
	
	# Test that inventory is properly attached to player
	var player := preload("res://scenes/player.tscn").instantiate()
	assert(player.inventory is Inventory)
	assert(player.inventory.count(&"gem") == 0)
	
	# Test pickup functionality
	var pickup := preload("res://scenes/pickup.tscn").instantiate()
	pickup.item_id = &"gem"
	pickup.qty = 3
	
	# Simulate pickup being picked up by player
	pickup._on_body_entered(player)
	assert(player.inventory.count(&"gem") == 3)
	assert(pickup.is_queued_for_deletion())
	
	print("All tests passed!")