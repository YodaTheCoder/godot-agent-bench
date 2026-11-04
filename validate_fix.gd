extends Node

func test_comprehensive():
	print("=== Comprehensive validation of fix ===")
	var weapon = Weapon.new()
	
	# Test 1: Default fire_rate = 4.0
	print("\nTest 1: fire_rate = 4.0")
	print("try_fire(0.0): ", weapon.try_fire(0.0))      # Should be true
	print("try_fire(0.2): ", weapon.try_fire(0.2))      # Should be false (0.2 < 0.25)
	print("try_fire(0.25): ", weapon.try_fire(0.25))    # Should be true (0.25 >= 0.25)
	
	# Test 2: fire_rate = 2.0 
	print("\nTest 2: fire_rate = 2.0")
	weapon.fire_rate = 2.0
	print("try_fire(0.0): ", weapon.try_fire(0.0))      # Should be true
	print("try_fire(0.4): ", weapon.try_fire(0.4))      # Should be false (0.4 < 0.5)
	print("try_fire(0.5): ", weapon.try_fire(0.5))      # Should be true (0.5 >= 0.5)
	
	# Test 3: fire_rate = 0.5
	print("\nTest 3: fire_rate = 0.5")
	weapon.fire_rate = 0.5
	print("try_fire(0.0): ", weapon.try_fire(0.0))      # Should be true
	print("try_fire(1.5): ", weapon.try_fire(1.5))      # Should be false (1.5 < 2.0)
	print("try_fire(2.0): ", weapon.try_fire(2.0))      # Should be true (2.0 >= 2.0)
	
	# Test 4: Check that blocking a shot doesn't reset the timer
	print("\nTest 4: Blocking does not reset cooldown")
	weapon.fire_rate = 4.0
	weapon.try_fire(0.0)   # Shot at 0.0
	print("try_fire(0.1): ", weapon.try_fire(0.1))      # Should be false (0.1 < 0.25)
	print("try_fire(0.3): ", weapon.try_fire(0.3))      # Should be true (0.3 >= 0.25)
	
	print("\nAll tests completed")

func _ready():
	test_comprehensive()
