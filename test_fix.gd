extends Node

func _ready() -> void:
	var health = Health.new()
	health.max_health = 100
	add_child(health)
	
	# Test 1: Normal healing within limit
	health.damage(10)
	health.heal(50)
	assert(health.current == 100, "Test 1 failed")
	
	# Test 2: Overhealing prevention
	health.heal(25)
	assert(health.current == 100, "Test 2 failed")
	
	# Test 3: Different max_health
	health.queue_free()
	health = Health.new()
	health.max_health = 40
	add_child(health)
	health.damage(10)
	health.heal(100)
	assert(health.current == 40, "Test 3 failed")
	
	# Test 4: Healing dead entity
	health.queue_free()
	health = Health.new()
	health.max_health = 100
	add_child(health)
	health.damage(100)  # Dead
	health.heal(20)
	assert(health.current == 0, "Test 4 failed")
	
	print("All tests passed!")