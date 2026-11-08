extends Node

const SAVE_PATH := "user://save.tres"

func save(player: Player, path: String = SAVE_PATH) -> Error:
	var data = SaveData.new()
	data.score = ScoreManager.score
	data.player_health = player.get_node("Health").current
	data.inventory = {}
	
	return ResourceSaver.save(data, path)

func load_into(player: Player, path: String = SAVE_PATH) -> bool:
	if not ResourceLoader.exists(path):
		return false
	
	var data = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
	if not (data is SaveData):
		return false
	
	ScoreManager.score = data.score
	player.get_node("Health").current = data.player_health
	
	return true