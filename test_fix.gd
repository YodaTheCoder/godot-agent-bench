extends Node

func _ready() -> void:
	# Test the default fire_rate = 4.0 (should be 4 shots per second, meaning 0.25 seconds between shots)
	var weapon = Weapon.new()
	
	# First shot should always succeed
	assert(weapon.try_fire(0.0) == true)
	
	# This should fail (only 0.2 seconds passed, need 0.25)
	assert(weapon.try_fire(0.2) == false)
	
	# This should succeed (0.25 seconds have passed)
	assert(weapon.try_fire(0.25) == true)
	
	print("Default fire_rate test passed")
	
	# Test fire_rate = 2.0 (should be 2 shots per second, meaning 0.5 seconds between shots)
	weapon.fire_rate = 2.0
	assert(weapon.try_fire(0.0) == true)
	assert(weapon.try_fire(0.4) == false)
	assert(weapon.try_fire(0.5) == true)
	
	print("fire_rate = 2.0 test passed")
	
	# Test fire_rate = 0.5 (should be 0.5 shots per second, meaning 2 seconds between shots)
	weapon.fire_rate = 0.5
	assert(weapon.try_fire(0.0) == true)
	assert(weapon.try_fire(1.5) == false)
	assert(weapon.try_fire(2.0) == true)
	
	print("fire_rate = 0.5 test passed")
	
	print("All tests passed!")