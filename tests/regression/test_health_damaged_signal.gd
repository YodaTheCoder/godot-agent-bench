extends GutTest

var health: Health


func before_each() -> void:
	health = Health.new()
	health.max_health = 100
	add_child_autofree(health)


func test_damage_emits_damaged_signal() -> void:
	watch_signals(health)
	health.damage(30)
	assert_eq(health.current, 70)
	assert_signal_emitted_with_args(health, "damaged", [30, 70])


func test_damage_emits_damaged_signal_twice() -> void:
	watch_signals(health)
	health.damage(30)
	assert_signal_emitted_with_args(health, "damaged", [30, 70])
	
	health.damage(20)
	assert_eq(health.current, 50)
	assert_signal_emitted_with_args(health, "damaged", [20, 50])


func test_damage_zero_does_not_emit_damaged() -> void:
	watch_signals(health)
	health.damage(0)
	assert_eq(health.current, 100)
	assert_signal_not_emitted(health, "damaged")


func test_lethal_damage_emits_damaged_then_died() -> void:
	watch_signals(health)
	health.damage(150)
	assert_eq(health.current, 0)
	assert_signal_emitted_with_args(health, "damaged", [100, 0])
	assert_signal_emitted(health, "died")


func test_damage_after_death_does_not_emit_damaged() -> void:
	watch_signals(health)
	health.damage(100) # kill it
	assert_signal_emitted(health, "died")
	
	health.damage(10) # try to damage more
	assert_eq(health.current, 0)
	assert_signal_not_emitted(health, "damaged")


func test_heal_does_not_emit_damaged() -> void:
	health.damage(50)
	watch_signals(health)
	health.heal(20)
	assert_eq(health.current, 70)
	assert_signal_not_emitted(health, "damaged")