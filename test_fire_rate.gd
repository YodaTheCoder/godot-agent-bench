extends Node

func _ready():
	var weapon = Weapon.new()
	
	# Test with default fire_rate = 4.0
	print("Testing with fire_rate = 4.0:")
	print("try_fire(0.0) -> %s" % weapon.try_fire(0.0))  # Should be true
	print("try_fire(0.2) -> %s" % weapon.try_fire(0.2))  # Should be false
	print("try_fire(0.25) -> %s" % weapon.try_fire(0.25))  # Should be true
	
	print("\nTesting with fire_rate = 2.0:")
	weapon.fire_rate = 2.0
	print("try_fire(0.0) -> %s" % weapon.try_fire(0.0))  # Should be true
	print("try_fire(0.4) -> %s" % weapon.try_fire(0.4))  # Should be false
	print("try_fire(0.5) -> %s" % weapon.try_fire(0.5))  # Should be true
	
	print("\nTesting with fire_rate = 0.5:")
	weapon.fire_rate = 0.5
	print("try_fire(0.0) -> %s" % weapon.try_fire(0.0))  # Should be true
	print("try_fire(1.5) -> %s" % weapon.try_fire(1.5))  # Should be false
	print("try_fire(2.0) -> %s" % weapon.try_fire(2.0))  # Should be true

func _process(delta):
	pass