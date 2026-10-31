extends GutTest

const PATH := "user://test_006_save_load.tres"
const OTHER_PATH := "user://test_006_not_save_data.tres"
const MISSING_PATH := "user://test_006_missing.tres"
const DEFAULT_PATH := "user://save.tres"

var player: Player
var health: Health


func _remove(path: String) -> void:
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func before_each() -> void:
	for p in [PATH, OTHER_PATH, MISSING_PATH]:
		_remove(p)
	ScoreManager.reset()
	player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	health = player.get_node("Health")


func after_each() -> void:
	for p in [PATH, OTHER_PATH, MISSING_PATH]:
		_remove(p)
	ScoreManager.reset()


func test_save_writes_save_data_resource() -> void:
	ScoreManager.score = 120
	health.damage(65)
	assert_eq(SaveGame.save(player, PATH), OK)
	assert_true(FileAccess.file_exists(PATH), "save file written")
	var data: Variant = ResourceLoader.load(PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
	assert_is(data, SaveData)
	if data is SaveData:
		assert_eq(data.score, 120)
		assert_eq(data.player_health, 35)
		assert_eq(data.inventory, {})


func test_round_trip_restores_score_and_health() -> void:
	ScoreManager.score = 120
	health.damage(65)
	SaveGame.save(player, PATH)
	ScoreManager.score = 7
	health.current = 100
	assert_true(SaveGame.load_into(player, PATH))
	assert_eq(ScoreManager.score, 120)
	assert_eq(health.current, 35)


func test_missing_file_returns_false_and_changes_nothing() -> void:
	ScoreManager.score = 50
	health.damage(20)
	assert_false(SaveGame.load_into(player, MISSING_PATH))
	assert_eq(ScoreManager.score, 50)
	assert_eq(health.current, 80)


func test_wrong_resource_type_returns_false() -> void:
	ResourceSaver.save(Resource.new(), OTHER_PATH)
	ScoreManager.score = 50
	health.damage(20)
	assert_false(SaveGame.load_into(player, OTHER_PATH))
	assert_eq(ScoreManager.score, 50)
	assert_eq(health.current, 80)


func test_default_path_is_user_save_tres() -> void:
	_remove(DEFAULT_PATH)
	ScoreManager.score = 9
	health.damage(1)
	SaveGame.save(player)
	assert_true(FileAccess.file_exists(DEFAULT_PATH), "default save file written")
	ScoreManager.score = 0
	health.current = 100
	assert_true(SaveGame.load_into(player))
	assert_eq(ScoreManager.score, 9)
	assert_eq(health.current, 99)
	_remove(DEFAULT_PATH)
