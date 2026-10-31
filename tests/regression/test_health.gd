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


func test_damaged_emitted_with_amount_and_remaining() -> void:
	watch_signals(health)
	health.damage(30)
	assert_signal_emit_count(health, "damaged", 1)
	assert_signal_emitted_with_parameters(health, "damaged", [30, 70])


func test_damaged_emitted_per_hit() -> void:
	watch_signals(health)
	health.damage(30)
	health.damage(20)
	assert_signal_emit_count(health, "damaged", 2)
	assert_signal_emitted_with_parameters(health, "damaged", [20, 50], 1)


func test_damaged_not_emitted_for_zero_damage() -> void:
	watch_signals(health)
	health.damage(0)
	assert_signal_not_emitted(health, "damaged")


func test_damaged_reports_actual_loss_on_overkill() -> void:
	var order := []
	health.damaged.connect(func(_a: int, _r: int) -> void: order.append("damaged"))
	health.died.connect(func() -> void: order.append("died"))
	watch_signals(health)
	health.damage(150)
	assert_signal_emitted_with_parameters(health, "damaged", [100, 0])
	assert_signal_emit_count(health, "died", 1)
	assert_eq(order, ["damaged", "died"])


func test_damaged_clamped_to_remaining_health() -> void:
	health.damage(70)
	watch_signals(health)
	health.damage(50)
	assert_signal_emitted_with_parameters(health, "damaged", [30, 0])


func test_damaged_not_emitted_after_death() -> void:
	health.damage(100)
	watch_signals(health)
	health.damage(10)
	assert_signal_not_emitted(health, "damaged")
	assert_signal_not_emitted(health, "died")


func test_heal_does_not_emit_damaged() -> void:
	health.damage(50)
	watch_signals(health)
	health.heal(20)
	assert_signal_not_emitted(health, "damaged")
