extends Node

const DEFAULT_PATH := "user://save.tres"


func save(player: Player, path: String = DEFAULT_PATH) -> Error:
	var data := SaveData.new()
	data.score = ScoreManager.score
	data.player_health = _health_of(player).current
	data.inventory = {}
	return ResourceSaver.save(data, path)


func load_into(player: Player, path: String = DEFAULT_PATH) -> bool:
	# A missing save is normal; check first so ResourceLoader doesn't print an error.
	if not ResourceLoader.exists(path):
		return false
	# Ignore the cache so a file re-saved at the same path is read fresh from disk.
	var data := ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE) as SaveData
	if data == null:
		return false
	ScoreManager.score = data.score
	_health_of(player).current = data.player_health
	return true


func _health_of(player: Player) -> Health:
	return player.get_node("Health") as Health
