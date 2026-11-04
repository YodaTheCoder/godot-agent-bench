# Validation script to verify our fix logic
extends Node

func test_fix_logic():
	# Test case 1: Healing past max_health should cap at max_health
	var health = Health.new()
	health.max_health = 100
	health.current = 90
	print("Test 1 - Before heal (90/100): %s" % health.current)
	health.heal(50)
	print("Test 1 - After heal (should be 100, not 140): %s" % health.current)
	assert(health.current == 100, "FAILED: Should cap at max_health")
	
	# Test case 2: Healing at full health should stay at full health
	health = Health.new()
	health.max_health = 100
	health.current = 100
	print("Test 2 - Before heal (100/100): %s" % health.current)
	health.heal(25)
	print("Test 2 - After heal (should stay at 100): %s" % health.current)
	assert(health.current == 100, "FAILED: Should stay at max_health")
	
	# Test case 3: Custom max_health
	health = Health.new()
	health.max_health = 40
	health.current = 30
	print("Test 3 - Before heal (30/40): %s" % health.current)
	health.heal(100)
	print("Test 3 - After heal (should be 40): %s" % health.current)
	assert(health.current == 40, "FAILED: Custom max_health should work")
	
	# Test case 4: Healing dead entity should do nothing
	health = Health.new()
	health.max_health = 100
	health.damage(100) # Kill the entity
	print("Test 4 - Before heal (dead at 0/100): %s" % health.current)
	health.heal(20)
	print("Test 4 - After heal on dead entity (should still be 0): %s" % health.current)
	assert(health.current == 0, "FAILED: Should not revive dead entities")
	
	# Test case 5: Normal healing should work
	health = Health.new()
	health.max_health = 100
	health.current = 50
	print("Test 5 - Before heal (50/100): %s" % health.current)
	health.heal(20)
	print("Test 5 - After heal (should be 70): %s" % health.current)
	assert(health.current == 70, "FAILED: Normal healing should work")
	
	print("All validation tests passed!")

# Run the validation
test_fix_logic()
