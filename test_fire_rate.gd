extends Node

func _ready():
	# Test the fix for fire_rate being treated as shots per second instead of seconds between shots
	
	var weapon = Weapon.new()
	add_child(weapon)
	
	print("Testing default fire_rate = 4.0")
	# Test 1: try_fire(0.0) → true
	assert(weapon.try_fire(0.0) == true)
	print("✓ try_fire(0.0) returned true")
	
	# Test 2: try_fire(0.2) → false (0.2 < 1/4 = 0.25 seconds)
	assert(weapon.try_fire(0.2) == false)
	print("✓ try_fire(0.2) returned false")
	
	# Test 3: try_fire(0.25) → true (0.25 >= 1/4 = 0.25 seconds)
	assert(weapon.try_fire(0.25) == true)
	print("✓ try_fire(0.25) returned true")
	
	print("Testing fire_rate = 2.0")
	weapon.fire_rate = 2.0
	# Test 1: try_fire(0.0) → true
	assert(weapon.try_fire(0.0) == true)
	print("✓ try_fire(0.0) returned true")
	
	# Test 2: try_fire(0.4) → false (0.4 < 1/2 = 0.5 seconds)
	assert(weapon.try_fire(0.4) == false)
	print("✓ try_fire(0.4) returned false")
	
	# Test 3: try_fire(0.5) → true (0.5 >= 1/2 = 0.5 seconds)
	assert(weapon.try_fire(0.5) == true)
	print("✓ try_fire(0.5) returned true")
	
	print("Testing fire_rate = 0.5")
	weapon.fire_rate = 0.5
	# Test 1: try_fire(0.0) → true
	assert(weapon.try_fire(0.0) == true)
	print("✓ try_fire(0.0) returned true")
	
	# Test 2: try_fire(1.5) → false (1.5 < 1/0.5 = 2 seconds)
	assert(weapon.try_fire(1.5) == false)
	print("✓ try_fire(1.5) returned false")
	
	# Test 3: try_fire(2.0) → true (2.0 >= 1/0.5 = 2 seconds)
	assert(weapon.try_fire(2.0) == true)
	print("✓ try_fire(2.0) returned true")
	
	print("All tests passed!")