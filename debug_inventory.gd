extends Node

func test_inventory_signal():
	print("Testing inventory signal emission...")
	
	var inv = Inventory.new()
	var call_count = 0
	
	# Connect the changed signal to count calls
	inv.connect("changed", func(): call_count += 1)
	
	# Test single add
	inv.add(&"coin")
	assert(call_count == 1)
	print("✓ Single add emits once")
	
	# Reset counter and test multiple adds
	call_count = 0
	inv.add(&"gem")
	inv.add(&"gem", 2)
	assert(call_count == 2)
	print("✓ Multiple adds emit correct number of times")

func test_requirements():
	print("\nTesting all requirements...")
	
	# Requirement: Inventory.new().count(&"coin") == 0
	var inv = Inventory.new()
	assert(inv.count(&"coin") == 0)
	print("✓ Empty inventory returns 0 for any item")
	
	# Requirement: add then add with qty -> correct count
	inv.add(&"coin")
	inv.add(&"coin", 4)
	assert(inv.count(&"coin") == 5)
	print("✓ Adding quantities works correctly")
	
	# Requirement: Different items independent  
	inv.add(&"gem")
	assert(inv.count(&"coin") == 5) # coin count unchanged
	assert(inv.count(&"gem") == 1)
	print("✓ Different items kept separate")
	
	# Player inventory requirement
	var player = preload("res://scenes/player.tscn").instantiate()
	assert(player.inventory is Inventory)
	assert(player.inventory.count(&"coin") == 0)
	print("✓ Player has inventory with correct initial state")

func _ready():
	print("Running comprehensive tests...")
	test_requirements()
	test_inventory_signal()
	print("\nAll requirements pass! ✓")
