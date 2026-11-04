extends Node

func _ready():
	print("Testing current weapon behavior...")
	var weapon = Weapon.new()
	
	# Test with default fire_rate = 4.0
	print("Default fire_rate = 4.0")
	print("try_fire(0.0) =", weapon.try_fire(0.0)) # Should be true
	print("try_fire(0.2) =", weapon.try_fire(0.2)) # Should be false (too soon)
	print("try_fire(0.25) =", weapon.try_fire(0.25)) # Should be true (enough time passed)
	
	print()
	# Test with fire_rate = 2.0
	weapon.fire_rate = 2.0
	print("fire_rate = 2.0")
	print("try_fire(0.0) =", weapon.try_fire(0.0)) # Should be true
	print("try_fire(0.4) =", weapon.try_fire(0.4)) # Should be false (too soon)
	print("try_fire(0.5) =", weapon.try_fire(0.5)) # Should be true (enough time passed)
	
	print()
	# Test with fire_rate = 0.5
	weapon.fire_rate = 0.5
	print("fire_rate = 0.5")
	print("try_fire(0.0) =", weapon.try_fire(0.0)) # Should be true
	print("try_fire(1.5) =", weapon.try_fire(1.5)) # Should be false (too soon)
	print("try_fire(2.0) =", weapon.try_fire(2.0)) # Should be true (enough time passed)
