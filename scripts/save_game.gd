extends Node

const DEFAULT_PATH := "user://save.tres"

func save(player: Player, path: String = DEFAULT_PATH) -> Error:
	var data := SaveData.new()
	data.score = ScoreManager.score
	data.player_health = player.get_node("Health").current
	data.inventory = {}
	return ResourceSaver.save(data, path)

func load_into(player: Player, path: String = DEFAULT_PATH) -> bool:
	if not FileAccess.file_exists(path):
		return false
	var loaded := ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
	if loaded == null or not loaded is SaveData:
		return false
	var data: SaveData = loaded as SaveData
	ScoreManager.score = data.score
	player.get_node("Health").current = data.player_health
	return true