extends GutTest

var health: Health


func before_each() -> void:
	health = Health.new()
	health.max_health = 100
	add_child_autofree(health)


func test_health_declares_damaged_signal() -> void:
	assert_has_signal(health, "damaged")


func test_damage_emits_amount_and_remaining() -> void:
	watch_signals(health)
	health.damage(30)
	assert_signal_emit_count(health, "damaged", 1)
	assert_signal_emitted_with_parameters(health, "damaged", [30, 70])


func test_each_hit_emits_once() -> void:
	watch_signals(health)
	health.damage(30)
	health.damage(20)
	assert_signal_emit_count(health, "damaged", 2)
	assert_signal_emitted_with_parameters(health, "damaged", [20, 50])


func test_zero_damage_does_not_emit() -> void:
	watch_signals(health)
	health.damage(0)
	assert_signal_not_emitted(health, "damaged")


func test_overkill_reports_health_actually_lost() -> void:
	watch_signals(health)
	health.damage(150)
	assert_signal_emitted_with_parameters(health, "damaged", [100, 0])


func test_damaged_is_emitted_before_died() -> void:
	var order: Array[String] = []
	if health.has_signal("damaged"):
		health.connect("damaged", func(_a: int, _r: int) -> void: order.append("damaged"))
	health.died.connect(func() -> void: order.append("died"))
	health.damage(100)
	assert_eq(order, ["damaged", "died"] as Array[String])


func test_no_emit_when_already_dead() -> void:
	health.damage(100)
	watch_signals(health)
	health.damage(10)
	assert_signal_not_emitted(health, "damaged")
