extends Node

func test_overheal():
	print("Testing overheal issue...")
	var health = Health.new()
	health.max_health = 100
	health.current = 90
	print("Before heal: " + str(health.current) + "/" + str(health.max_health))
	health.heal(50)
	print("After heal: " + str(health.current) + "/" + str(health.max_health))
	print("Expected: 100/100, Actual: " + str(health.current) + "/" + str(health.max_health))
	print()

func test_revive_issue():
	print("Testing revive issue...")
	var health = Health.new()
	health.max_health = 100
	health.damage(100)
	print("After damage (should be dead): " + str(health.current) + "/" + str(health.max_health))
	print("Is dead: " + str(health.current == 0))
	health.heal(20)
	print("After heal (should still be dead): " + str(health.current) + "/" + str(health.max_health))
	print("Expected: 0/100, Actual: " + str(health.current) + "/" + str(health.max_health))
	print()

func test_normal_heal():
	print("Testing normal heal...")
	var health = Health.new()
	health.max_health = 100
	health.current = 50
	print("Before heal: " + str(health.current) + "/" + str(health.max_health))
	health.heal(20)
	print("After heal: " + str(health.current) + "/" + str(health.max_health))
	print("Expected: 70/100, Actual: " + str(health.current) + "/" + str(health.max_health))
	print()

func test_different_max_health():
	print("Testing different max health...")
	var health = Health.new()
	health.max_health = 40
	health.current = 30
	print("Before heal: " + str(health.current) + "/" + str(health.max_health))
	health.heal(100)
	print("After heal: " + str(health.current) + "/" + str(health.max_health))
	print("Expected: 40/40, Actual: " + str(health.current) + "/" + str(health.max_health))
	print()

func _ready() -> void:
	test_overheal()
	test_revive_issue()
	test_normal_heal()
	test_different_max_health()
