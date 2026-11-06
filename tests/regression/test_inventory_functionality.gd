extends "res://tests/regression/test_player.gd"

func test_inventory_functionality() -> void:
	var inventory = Inventory.new()
	assert_eq(inventory.count(&"coin"), 0)
	
	inventory.add(&"coin")
	inventory.add(&"coin", 4)
	assert_eq(inventory.count(&"coin"), 5)
	assert_eq(inventory.count(&"gem"), 0)
	
	# Test that each add emits changed signal exactly once
	var changed_emitted = false
	inventory.connect("changed", func(): changed_emitted = true)
	
	inventory.add(&"gem")
	assert_true(changed_emitted)
	
	changed_emitted = false
	inventory.add(&"gem", 2)
	assert_true(changed_emitted)