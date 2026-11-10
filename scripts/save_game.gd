extends Node

const SAVE_FILE_PATH = "user://save.tres"

func save(player: Player, path: String = SAVE_FILE_PATH) -> Error:
	var save_data = preload("res://scripts/save_data.gd").new()
	save_data.score = ScoreManager.score
	save_data.player_health = player.get_node("Health").current
	save_data.inventory = {}
	
	return ResourceSaver.save(save_data, path)

func load_into(player: Player, path: String = SAVE_FILE_PATH) -> bool:
	if not ResourceLoader.exists(path):
		return false
	
	var data = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
	if not data is SaveData:
		return false
	
	ScoreManager.score = data.score
	player.get_node("Health").current = data.player_health
	
	return true