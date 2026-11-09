extends Node

func _ready() -> void:
	print("=== Verifying Weapon Cooldown Implementation ===")
	
	# Test 1: Default fire_rate = 4.0
	var weapon = Weapon.new()
	print("\nTest 1: fire_rate = 4.0 (cooldown = 1/4 = 0.25 seconds)")
	print("try_fire(0.0): ", weapon.try_fire(0.0)) # Should be true
	print("try_fire(0.2): ", weapon.try_fire(0.2)) # Should be false (0.2 - 0.0 = 0.2 < 0.25)
	print("try_fire(0.25): ", weapon.try_fire(0.25)) # Should be true (0.25 - 0.0 = 0.25 >= 0.25)
	
	# Test 2: fire_rate = 2.0
	var weapon2 = Weapon.new()
	weapon2.fire_rate = 2.0
	print("\nTest 2: fire_rate = 2.0 (cooldown = 1/2 = 0.5 seconds)")
	print("try_fire(0.0): ", weapon2.try_fire(0.0)) # Should be true
	print("try_fire(0.4): ", weapon2.try_fire(0.4)) # Should be false (0.4 - 0.0 = 0.4 < 0.5)
	print("try_fire(0.5): ", weapon2.try_fire(0.5)) # Should be true (0.5 - 0.0 = 0.5 >= 0.5)
	
	# Test 3: fire_rate = 0.5
	var weapon3 = Weapon.new()
	weapon3.fire_rate = 0.5
	print("\nTest 3: fire_rate = 0.5 (cooldown = 1/0.5 = 2.0 seconds)")
	print("try_fire(0.0): ", weapon3.try_fire(0.0)) # Should be true
	print("try_fire(1.5): ", weapon3.try_fire(1.5)) # Should be false (1.5 - 0.0 = 1.5 < 2.0)
	print("try_fire(2.0): ", weapon3.try_fire(2.0)) # Should be true (2.0 - 0.0 = 2.0 >= 2.0)
	
	print("\n=== Verification Complete ===")

