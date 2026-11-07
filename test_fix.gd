extends Node

func _ready() -> void:
	var weapon = Weapon.new()
	
	# Test with default fire_rate = 4.0 (should fire every 0.25 seconds)
	print("Testing default fire_rate = 4.0")
	print("try_fire(0.0): ", weapon.try_fire(0.0))  # Should be true
	print("try_fire(0.2): ", weapon.try_fire(0.2))  # Should be false
	print("try_fire(0.25): ", weapon.try_fire(0.25))  # Should be true
	
	# Test with fire_rate = 2.0 (should fire every 0.5 seconds)
	weapon.fire_rate = 2.0
	print("\nTesting fire_rate = 2.0")
	print("try_fire(0.0): ", weapon.try_fire(0.0))  # Should be true
	print("try_fire(0.4): ", weapon.try_fire(0.4))  # Should be false
	print("try_fire(0.5): ", weapon.try_fire(0.5))  # Should be true
	
	# Test with fire_rate = 0.5 (should fire every 2.0 seconds)
	weapon.fire_rate = 0.5
	print("\nTesting fire_rate = 0.5")
	print("try_fire(0.0): ", weapon.try_fire(0.0))  # Should be true
	print("try_fire(1.5): ", weapon.try_fire(1.5))  # Should be false
	print("try_fire(2.0): ", weapon.try_fire(2.0))  # Should be true
	
	print("\nTest completed")

func _process(_delta: float) -> void:
	pass