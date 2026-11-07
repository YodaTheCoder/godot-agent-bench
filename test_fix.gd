extends Node

func _ready() -> void:
	# Test the fix for Health.heal()
	var health = Health.new()
	health.max_health = 100
	add_child(health)
	
	# Test 1: Healing past max_health should be capped
	health.current = 90
	health.heal(50)
	assert(health.current == 100, "Healing past max_health should be capped")
	
	# Test 2: At full health, healing should still cap at max_health
	health.current = 100
	health.heal(25)
	assert(health.current == 100, "At full health, healing should still cap at max_health")
	
	# Test 3: Different max_health value
	health.max_health = 40
	health.current = 30
	health.heal(100)
	assert(health.current == 40, "Different max_health should be respected")
	
	# Test 4: Healing dead entity should do nothing
	health.current = 0
	health.heal(20)
	assert(health.current == 0, "Healing dead entity should do nothing")
	
	print("All tests passed!")