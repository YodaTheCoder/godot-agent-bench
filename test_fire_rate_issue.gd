extends Node

func test_current_behavior():
	print("Testing current behavior with fire_rate = 4.0")
	var weapon = Weapon.new()
	
	# First shot should always succeed
	print("try_fire(0.0): ", weapon.try_fire(0.0))  # Should be true
	
	# Next shot at 0.2s - this should fail (too early)
	print("try_fire(0.2): ", weapon.try_fire(0.2))  # Should be false
	
	# Next shot at 0.25s - this should succeed (0.25 - 0.0 = 0.25, but fire_rate is 4.0 so cooldown is 0.25s)
	print("try_fire(0.25): ", weapon.try_fire(0.25))  # This fails with current implementation
	
	# Test with fire_rate = 2.0
	print("\nTesting with fire_rate = 2.0")
	weapon.fire_rate = 2.0
	print("try_fire(0.0): ", weapon.try_fire(0.0))   # Should be true
	print("try_fire(0.4): ", weapon.try_fire(0.4))   # Should be false (too early)
	print("try_fire(0.5): ", weapon.try_fire(0.5))   # Should be true (0.5 - 0.0 = 0.5, and 0.5 >= 1.0/2.0 = 0.5)

	# Test with fire_rate = 0.5
	print("\nTesting with fire_rate = 0.5")
	weapon.fire_rate = 0.5
	print("try_fire(0.0): ", weapon.try_fire(0.0))   # Should be true
	print("try_fire(1.5): ", weapon.try_fire(1.5))   # Should be false (too early)
	print("try_fire(2.0): ", weapon.try_fire(2.0))   # Should be true

func _ready():
	test_current_behavior()
