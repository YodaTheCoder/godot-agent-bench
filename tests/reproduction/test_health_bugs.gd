extends Node

func test_overheal_bug():
	var health = Health.new()
	health.max_health = 100
	health.current = 90
	print("Before heal: %s" % health.current)
	health.heal(50)
	print("After heal (should be 100, not 140): %s" % health.current)
	assert(health.current == 100, "Overheal bug: should not exceed max_health")

func test_dead_entity_heal_bug():
	var health = Health.new()
	health.max_health = 100
	health.damage(100) # Kill it
	print("Before heal (should be 0): %s" % health.current)
	health.heal(20) # Try to heal dead entity
	print("After heal (should still be 0): %s" % health.current)
	assert(health.current == 0, "Dead entity heal bug: should not revive dead entities")

func test_normal_healing():
	var health = Health.new()
	health.max_health = 100
	health.damage(50) # Reduce to 50
	print("Before heal (should be 50): %s" % health.current)
	health.heal(20) # Heal by 20
	print("After heal (should be 70): %s" % health.current)
	assert(health.current == 70, "Normal healing should work")

func test_different_max_health():
	var health = Health.new()
	health.max_health = 40
	health.damage(10) # Reduce to 30
	print("Before heal (should be 30): %s" % health.current)
	health.heal(100) # Heal by 100 (should cap at 40)
	print("After heal (should be 40, not 130): %s" % health.current)
	assert(health.current == 40, "Different max_health should work correctly")

func run_all_tests():
	print("Running reproduction tests...")
	test_overheal_bug()
	test_dead_entity_heal_bug()
	test_normal_healing()
	test_different_max_health()
	print("All tests completed!")
