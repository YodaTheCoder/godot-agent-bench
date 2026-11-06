extends "res://tests/regression/test_player.gd"

func test_inventory_starts_empty() -> void:
	var player = preload("res://scenes/player.tscn").instantiate()
	assert_eq(player.inventory.count(&"coin"), 0)