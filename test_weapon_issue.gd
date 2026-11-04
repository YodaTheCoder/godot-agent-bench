extends Node

func _ready():
	print("Testing Weapon fire_rate issue...")
	
	var weapon = Weapon.new()
	
	# Test default fire_rate = 4.0
	print("Default fire_rate = 4.0")
	print("try_fire(0.0): ", weapon.try_fire(0.0))  # Should be true
	print("try_fire(0.2): ", weapon.try_fire(0.2))  # Should be false (too soon)
	print("try_fire(0.25): ", weapon.try_fire(0.25))  # Should be true (0.25 - 0.0 = 0.25, which is > 1/4 = 0.25)
	
	print("\nTesting fire_rate = 2.0")
	weapon.fire_rate = 2.0
	print("try_fire(0.0): ", weapon.try_fire(0.0))  # Should be true
	print("try_fire(0.4): ", weapon.try_fire(0.4))  # Should be false (too soon)
	print("try_fire(0.5): ", weapon.try_fire(0.5))  # Should be true (0.5 - 0.0 = 0.5, which is >= 1/2 = 0.5)
	
	print("\nTesting fire_rate = 0.5")
	weapon.fire_rate = 0.5
	print("try_fire(0.0): ", weapon.try_fire(0.0))  # Should be true
	print("try_fire(1.5): ", weapon.try_fire(1.5))  # Should be false (too soon)
	print("try_fire(2.0): ", weapon.try_fire(2.0))  # Should be true (2.0 - 0.0 = 2.0, which is >= 1/0.5 = 2.0)

