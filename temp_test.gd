extends Node

func _ready():
	# Quick validation of functionality
	var inv = Inventory.new()
	
	# Test 1: Initial count is 0 for non-existent items
	assert(inv.count(&"coin") == 0)
	print("✓ Test 1 passed: Initial count")
	
	# Test 2: Add one item
	inv.add(&"coin")
	assert(inv.count(&"coin") == 1)
	print("✓ Test 2 passed: Single add")
	
	# Test 3: Add with quantity
	inv.add(&"coin", 4)
	assert(inv.count(&"coin") == 5)
	print("✓ Test 3 passed: Add with quantity")
	
	# Test 4: Different items independent
	inv.add(&"gem")
	assert(inv.count(&"coin") == 5)
	assert(inv.count(&"gem") == 1)
	print("✓ Test 4 passed: Different items")
	
	print("All basic tests pass!")
