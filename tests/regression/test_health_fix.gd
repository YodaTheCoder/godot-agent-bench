extends GutTest

var health: Health


func before_each() -> void:
	health = Health.new()
	add_child_autofree(health)


func test_heal_capped_at_max_health() -> void:
	health.max_health = 100
	health.damage(10)
	health.heal(50)
	assert_eq(health.current, 100)


func test_heal_at_max_health() -> void:
	health.max_health = 100
	health.heal(25)
	assert_eq(health.current, 100)


func test_heal_different_max_health() -> void:
	health.max_health = 40
	health.damage(10)
	health.heal(100)
	assert_eq(health.current, 40)


func test_heal_dead_entity() -> void:
	health.damage(100) # Kill the entity
	health.heal(20)
	assert_eq(health.current, 0)


func test_heal_below_max_still_works() -> void:
	health.max_health = 100
	health.damage(50)
	health.heal(20)
	assert_eq(health.current, 70)