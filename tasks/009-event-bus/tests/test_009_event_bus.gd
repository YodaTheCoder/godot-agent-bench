extends GutTest


func before_each() -> void:
	ScoreManager.reset()


func after_each() -> void:
	ScoreManager.reset()


func _events() -> Node:
	return get_tree().root.get_node_or_null("Events")


func test_events_autoload_declares_enemy_died() -> void:
	var events := _events()
	assert_not_null(events, "autoload /root/Events exists")
	if events == null:
		return
	assert_true(events.has_signal("enemy_died"))
	var args := []
	for sig in events.get_signal_list():
		if sig["name"] == "enemy_died":
			args = sig["args"]
	assert_eq(args.size(), 1, "enemy_died has one argument")


func test_events_is_loaded_before_score_manager() -> void:
	var events := _events()
	assert_not_null(events)
	if events == null:
		return
	var score_manager := get_tree().root.get_node("ScoreManager")
	assert_lt(events.get_index(), score_manager.get_index())


func test_emitting_enemy_died_adds_points_once() -> void:
	var events := _events()
	assert_not_null(events)
	if events == null:
		return
	events.emit_signal("enemy_died", 10)
	assert_eq(ScoreManager.score, 10)
	events.emit_signal("enemy_died", 25)
	assert_eq(ScoreManager.score, 35)


func test_score_manager_is_the_listener() -> void:
	var events := _events()
	assert_not_null(events)
	if events == null:
		return
	var listeners := []
	for connection in events.get_signal_connection_list("enemy_died"):
		listeners.append(connection["callable"].get_object())
	assert_has(listeners, ScoreManager)


func test_enemy_script_does_not_mention_score_manager() -> void:
	var source := FileAccess.get_file_as_string("res://scripts/enemy.gd")
	assert_ne(source, "", "enemy.gd readable")
	assert_false(source.contains("ScoreManager"))


func test_killing_enemy_emits_event_and_scores() -> void:
	var events := _events()
	assert_not_null(events)
	if events == null:
		return
	var enemy: Enemy = add_child_autofree(load("res://scenes/enemy.tscn").instantiate())
	enemy.points = 25
	watch_signals(events)
	var health: Health = enemy.get_node("Health")
	health.damage(health.max_health)
	assert_signal_emitted_with_parameters(events, "enemy_died", [25])
	assert_signal_emit_count(events, "enemy_died", 1)
	assert_eq(ScoreManager.score, 25)
	assert_true(enemy.is_queued_for_deletion())
