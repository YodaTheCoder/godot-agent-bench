extends Node

func run_tests():
	print("Testing fixed weapon behavior")
	
	# Test 1: Default fire_rate = 4.0
	print("\n=== Test 1: fire_rate = 4.0 ===")
	var weapon = Weapon.new()
	weapon.fire_rate = 4.0
	
	# First shot should always be allowed
	var result1 = weapon.try_fire(0.0)
	print("try_fire(0.0) = %s (should be true)" % result1)
	
	# 0.2 seconds is less than 0.25 seconds needed between shots (1/4 = 0.25)
	var result2 = weapon.try_fire(0.2)
	print("try_fire(0.2) = %s (should be false)" % result2)
	
	# 0.25 seconds is exactly the required interval
	var result3 = weapon.try_fire(0.25)
	print("try_fire(0.25) = %s (should be true)" % result3)
	
	# Test 2: fire_rate = 2.0
	print("\n=== Test 2: fire_rate = 2.0 ===")
	weapon.fire_rate = 2.0
	
	# First shot should always be allowed
	var result4 = weapon.try_fire(0.0)
	print("try_fire(0.0) = %s (should be true)" % result4)
	
	# 0.4 seconds is less than 0.5 seconds needed between shots (1/2 = 0.5)
	var result5 = weapon.try_fire(0.4)
	print("try_fire(0.4) = %s (should be false)" % result5)
	
	# 0.5 seconds is exactly the required interval
	var result6 = weapon.try_fire(0.5)
	print("try_fire(0.5) = %s (should be true)" % result6)
	
	# Test 3: fire_rate = 0.5
	print("\n=== Test 3: fire_rate = 0.5 ===")
	weapon.fire_rate = 0.5
	
	# First shot should always be allowed
	var result7 = weapon.try_fire(0.0)
	print("try_fire(0.0) = %s (should be true)" % result7)
	
	# 1.5 seconds is less than 2 seconds needed between shots (1/0.5 = 2)
	var result8 = weapon.try_fire(1.5)
	print("try_fire(1.5) = %s (should be false)" % result8)
	
	# 2.0 seconds is exactly the required interval
	var result9 = weapon.try_fire(2.0)
	print("try_fire(2.0) = %s (should be true)" % result9)

func _ready():
	run_tests()
