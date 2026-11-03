extends GutTest

var health: Health


func before_each() -> void:
	health = Health.new()
	health.max_health = 100
	add_child_autofree(health)


func test_starts_at_max_health() -> void:
	assert_eq(health.current, 100)


func test_damage_reduces_current() -> void:
	health.damage(30)
	assert_eq(health.current, 70)


func test_died_emitted_at_zero() -> void:
	watch_signals(health)
	health.damage(100)
	assert_eq(health.current, 0)
	assert_signal_emitted(health, "died")


func test_died_not_emitted_while_alive() -> void:
	watch_signals(health)
	health.damage(99)
	assert_signal_not_emitted(health, "died")


func test_heal_restores_health_below_max() -> void:
	health.damage(50)
	health.heal(20)
	assert_eq(health.current, 70)

func test_heal_does_not_exceed_max_health() -> void:
	health.damage(50)
	health.heal(100)
	assert_eq(health.current, 100)

func test_heal_does_not_work_on_dead_entity() -> void:
	health.damage(100)
	health.heal(20)
	assert_eq(health.current, 0)


func test_heal_with_custom_max_health() -> void:
	health.max_health = 40
	health.current = 40
	health.damage(10)
	health.heal(100)
	assert_eq(health.current, 40)

