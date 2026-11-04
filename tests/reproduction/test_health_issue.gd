extends Node

func test_overheal():
	var health = Health.new()
	health.max_health = 100
	health.current = 90
	print("Before heal: %s" % health.current)
	health.heal(50)
	print("After heal (should be 100, not 140): %s" % health.current)
	assert(health.current == 100, "Healing should not overheal")

func test_heal_dead_entity():
	var health = Health.new()
	health.max_health = 100
	health.damage(100) # Kill the entity
	print("Before heal (dead): %s" % health.current)
	health.heal(20)
	print("After heal on dead entity (should still be 0): %s" % health.current)
	assert(health.current == 0, "Healing should not revive dead entities")

func test_normal_heal():
	var health = Health.new()
	health.max_health = 100
	health.current = 50
	print("Before heal (normal): %s" % health.current)
	health.heal(20)
	print("After heal (should be 70): %s" % health.current)
	assert(health.current == 70, "Normal healing should work")

func test_different_max_health():
	var health = Health.new()
	health.max_health = 40
	health.current = 30
	print("Before heal (custom max): %s" % health.current)
	health.heal(100)
	print("After heal with custom max (should be 40): %s" % health.current)
	assert(health.current == 40, "Custom max health should work")

func run_all_tests():
	test_overheal()
	test_heal_dead_entity()
	test_normal_heal()
	test_different_max_health()
	print("All tests completed")
