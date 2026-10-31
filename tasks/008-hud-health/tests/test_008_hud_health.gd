extends GutTest


func before_each() -> void:
	ScoreManager.reset()


func after_each() -> void:
	ScoreManager.reset()


func _make_hud() -> HUD:
	return add_child_autofree(load("res://scenes/hud.tscn").instantiate())


func _make_health(max_hp: int) -> Health:
	var health := Health.new()
	health.max_health = max_hp
	add_child_autofree(health)
	return health


func test_health_label_exists() -> void:
	var hud := _make_hud()
	assert_is(hud.health_label, Label)
	assert_eq(hud.get_node("HealthLabel"), hud.health_label)


func test_bind_shows_current_health_immediately() -> void:
	var hud := _make_hud()
	hud.bind_health(_make_health(40))
	assert_eq(hud.health_label.text, "HP: 40/40")


func test_label_follows_damage_and_heal() -> void:
	var hud := _make_hud()
	var health := _make_health(100)
	hud.bind_health(health)
	health.damage(30)
	assert_eq(hud.health_label.text, "HP: 70/100")
	health.heal(10)
	assert_eq(hud.health_label.text, "HP: 80/100")
	health.damage(500)
	assert_eq(hud.health_label.text, "HP: 0/100")


func test_health_emits_health_changed() -> void:
	var health := _make_health(100)
	watch_signals(health)
	health.damage(30)
	assert_signal_emitted_with_parameters(health, "health_changed", [70, 100])
	health.heal(5)
	assert_signal_emitted_with_parameters(health, "health_changed", [75, 100])
	assert_signal_emit_count(health, "health_changed", 2)


func test_score_label_updates_from_signal() -> void:
	var hud := _make_hud()
	assert_eq(hud.score_label.text, "Score: 0")
	ScoreManager.add_points(10)
	assert_eq(hud.score_label.text, "Score: 10")
	ScoreManager.reset()
	assert_eq(hud.score_label.text, "Score: 0")


func test_hud_does_not_poll_every_frame() -> void:
	var hud := _make_hud()
	var names: Array[String] = []
	for method in hud.get_script().get_script_method_list():
		names.append(method["name"])
	assert_false(names.has("_process"), "hud.gd must not define _process")
	assert_false(names.has("_physics_process"), "hud.gd must not define _physics_process")
