# Test script to verify save/load functionality
extends SceneTree

func _init():
	print("Testing save/load functionality...")
	
	# Create a mock player with health
	var player = Player.new()
	player.name = "Player"
	player.get_node("Health").current = 35
	
	# Set up score manager
	var score_manager = ScoreManager.new()
	score_manager.score = 120
	
	# Test save
	var result = SaveGame.save(player)
	print("Save result: ", result)
	
	# Test load
	var loaded = SaveGame.load_into(player)
	print("Load result: ", loaded)
	print("Score after load: ", score_manager.score)
	print("Health after load: ", player.get_node("Health").current)
	
	# Clean up
	player.queue_free()