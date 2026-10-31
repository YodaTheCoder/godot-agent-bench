extends GutTest

const TEST_PATH := "user://test_save_game.tres"
const OTHER_PATH := "user://test_save_game_other.tres"
const MISSING_PATH := "user://test_save_game_missing.tres"

var player: Player


func before_each() -> void:
	player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	ScoreManager.reset()


func after_each() -> void:
	ScoreManager.reset()
	for path in [TEST_PATH, OTHER_PATH]:
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(path)


func _health() -> Health:
	return player.get_node("Health")


func test_save_writes_score_health_and_empty_inventory() -> void:
	ScoreManager.score = 120
	_health().current = 35
	assert_eq(SaveGame.save(player, TEST_PATH), OK)
	assert_true(FileAccess.file_exists(TEST_PATH))
	var data := ResourceLoader.load(TEST_PATH, "", ResourceLoader.CACHE_MODE_IGNORE) as SaveData
	assert_not_null(data)
	assert_eq(data.score, 120)
	assert_eq(data.player_health, 35)
	assert_eq(data.inventory, {})


func test_load_into_restores_saved_state() -> void:
	ScoreManager.score = 120
	_health().current = 35
	SaveGame.save(player, TEST_PATH)
	ScoreManager.score = 5
	_health().current = 1
	assert_true(SaveGame.load_into(player, TEST_PATH))
	assert_eq(ScoreManager.score, 120)
	assert_eq(_health().current, 35)


func test_load_into_sees_resaved_contents() -> void:
	ScoreManager.score = 10
	SaveGame.save(player, TEST_PATH)
	SaveGame.load_into(player, TEST_PATH)
	ScoreManager.score = 20
	SaveGame.save(player, TEST_PATH)
	ScoreManager.score = 0
	assert_true(SaveGame.load_into(player, TEST_PATH))
	assert_eq(ScoreManager.score, 20)


func test_load_into_missing_file_returns_false_and_changes_nothing() -> void:
	ScoreManager.score = 7
	_health().current = 42
	assert_false(SaveGame.load_into(player, MISSING_PATH))
	assert_eq(ScoreManager.score, 7)
	assert_eq(_health().current, 42)


func test_load_into_other_resource_type_returns_false_and_changes_nothing() -> void:
	ResourceSaver.save(Resource.new(), OTHER_PATH)
	ScoreManager.score = 7
	_health().current = 42
	assert_false(SaveGame.load_into(player, OTHER_PATH))
	assert_eq(ScoreManager.score, 7)
	assert_eq(_health().current, 42)
