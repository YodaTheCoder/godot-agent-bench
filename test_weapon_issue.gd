extends Node

func test_current_behavior():
	print("Testing current weapon behavior with fire_rate = 4.0")
	var weapon = Weapon.new()
	weapon.fire_rate = 4.0
	
	# Test case 1: try_fire(0.0) should return true
	var result1 = weapon.try_fire(0.0)
	print("try_fire(0.0) = %s" % result1)
	
	# Test case 2: try_fire(0.2) should return false (too soon)
	var result2 = weapon.try_fire(0.2)
	print("try_fire(0.2) = %s" % result2)
	
	# Test case 3: try_fire(0.25) should return true (0.25 - 0.0 = 0.25 seconds passed, but fire_rate=4 means 0.25s between shots, so at least 0.25s has passed)
	print("Expected: With fire_rate=4, we need 1/4 = 0.25 seconds between shots")
	
	# Test case with fire_rate = 2.0
	print("\nTesting with fire_rate = 2.0")
	weapon.fire_rate = 2.0
	var result3 = weapon.try_fire(0.0)
	print("try_fire(0.0) = %s" % result3)
	
	var result4 = weapon.try_fire(0.4)
	print("try_fire(0.4) = %s" % result4)
	
	var result5 = weapon.try_fire(0.5)
	print("try_fire(0.5) = %s" % result5)

func _ready():
	test_current_behavior()
