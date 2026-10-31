extends GutTest


func before_each() -> void:
	ScoreManager.reset()


func after_each() -> void:
	ScoreManager.reset()


func test_events_autoload_precedes_score_manager() -> void:
	var root := get_tree().root
	var events := root.get_node_or_null("Events")
	assert_not_null(events)
	assert_true(events.has_signal("enemy_died"))
	assert_lt(events.get_index(), root.get_node("ScoreManager").get_index())


func test_enemy_died_adds_points_once_per_emission() -> void:
	Events.enemy_died.emit(10)
	assert_eq(ScoreManager.score, 10)
	Events.enemy_died.emit(25)
	assert_eq(ScoreManager.score, 35)


func test_score_manager_listens_to_enemy_died() -> void:
	var owners := Events.enemy_died.get_connections().map(
		func(c: Dictionary) -> Object: return c.callable.get_object())
	assert_has(owners, ScoreManager)


func test_reset_keeps_listener_connected() -> void:
	ScoreManager.reset()
	Events.enemy_died.emit(5)
	assert_eq(ScoreManager.score, 5)
