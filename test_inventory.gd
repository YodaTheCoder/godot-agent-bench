extends Node

func test_inventory_basic():
	print("Testing inventory creation and basic functions...")
	var inv = Inventory.new()
	assert(inv.count(&"coin") == 0)
	print("✓ Basic count works")
	
	inv.add(&"coin")
	assert(inv.count(&"coin") == 1)
	print("✓ Simple add works")
	
	inv.add(&"coin", 4)
	assert(inv.count(&"coin") == 5)
	print("✓ Add with quantity works")
	
	inv.add(&"gem")
	assert(inv.count(&"gem") == 1)
	assert(inv.count(&"coin") == 5) 
	print("✓ Different items independent")
	
	print("All tests passed!")

func test_player_inventory():
	print("\nTesting player inventory...")
	var player = preload("res://scenes/player.tscn").instantiate()
	assert(player.inventory != null)
	assert(player.inventory is Inventory)
	assert(player.inventory.count(&"coin") == 0)
	print("✓ Player has proper inventory")

func _ready():
	test_inventory_basic()
	test_player_inventory()
	print("\nAll tests passed! ✓")
