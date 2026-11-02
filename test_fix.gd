extends Node

func _ready():
	# Test the fix with default fire_rate = 4.0
	var weapon = Weapon.new()
	
	# Test case 1: Default fire_rate = 4.0
	print("=== Testing default fire_rate = 4.0 ===")
	var result1 = weapon.try_fire(0.0)  # Should return true
	print("try_fire(0.0) =", result1)
	
	var result2 = weapon.try_fire(0.2)  # Should return false (0.2 < 1/4 = 0.25)
	print("try_fire(0.2) =", result2)
	
	var result3 = weapon.try_fire(0.25)  # Should return true (0.25 >= 0.25)
	print("try_fire(0.25) =", result3)
	
	# Test case 2: fire_rate = 2.0
	print("\n=== Testing fire_rate = 2.0 ===")
	weapon.fire_rate = 2.0
	var result4 = weapon.try_fire(0.0)   # Should return true
	print("try_fire(0.0) =", result4)
	
	var result5 = weapon.try_fire(0.4)  # Should return false (0.4 < 1/2 = 0.5)
	print("try_fire(0.4) =", result5)
	
	var result6 = weapon.try_fire(0.5)  # Should return true (0.5 >= 0.5)
	print("try_fire(0.5) =", result6)
	
	# Test case 3: fire_rate = 0.5
	print("\n=== Testing fire_rate = 0.5 ===")
	weapon.fire_rate = 0.5
	var result7 = weapon.try_fire(0.0)   # Should return true
	print("try_fire(0.0) =", result7)
	
	var result8 = weapon.try_fire(1.5)  # Should return false (1.5 < 1/0.5 = 2.0)
	print("try_fire(1.5) =", result8)
	
	var result9 = weapon.try_fire(2.0)  # Should return true (2.0 >= 2.0)
	print("try_fire(2.0) =", result9)