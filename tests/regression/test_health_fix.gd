extends GutTest

var health: Health


func before_each() -> void:
	health = Health.new()
	add_child_autofree(health)


func test_heal_does_not_overheal() -> void:
	health.max_health = 100
	health.damage(10)
	health.heal(50)
	assert_eq(health.current, 100)


func test_heal_at_max_health() -> void:
	health.max_health = 100
	health.heal(25)
	assert_eq(health.current, 100)


func test_heal_with_different_max_health() -> void:
	health.max_health = 40
	health.damage(10)
	health.heal(100)
	assert_eq(health.current, 40)


func test_heal_does_not_revive_dead_entity() -> void:
	health.damage(100)
	assert_eq(health.current, 0)
	health.heal(20)
	assert_eq(health.current, 0)


func test_normal_heal_works() -> void:
	health.max_health = 100
	health.damage(50)
	health.heal(20)
	assert_eq(health.current, 70)