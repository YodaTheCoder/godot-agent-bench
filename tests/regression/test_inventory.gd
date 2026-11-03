extends "res://tests/regression/test_player.gd"

func test_inventory_creation() -> void:
	var player := preload("res://scenes/player.tscn").instantiate()
	assert(player.inventory != null)
	assert(player.inventory.count(&"coin") == 0)
	player.queue_free()

func test_inventory_add() -> void:
	var player := preload("res://scenes/player.tscn").instantiate()
	player.inventory.add(&"coin")
	assert(player.inventory.count(&"coin") == 1)
	player.inventory.add(&"coin", 4)
	assert(player.inventory.count(&"coin") == 5)
	player.queue_free()

func test_inventory_isolated() -> void:
	var player := preload("res://scenes/player.tscn").instantiate()
	player.inventory.add(&"coin")
	player.inventory.add(&"gem", 2)
	assert(player.inventory.count(&"coin") == 1)
	assert(player.inventory.count(&"gem") == 2)
	player.queue_free()

func test_inventory_changed_signal() -> void:
	var player := preload("res://scenes/player.tscn").instantiate()
	var changed_count = 0
	player.inventory.changed.connect(func() : changed_count += 1)
	player.inventory.add(&"coin")
	assert(changed_count == 1)
	player.inventory.add(&"coin", 4)
	assert(changed_count == 2)
	player.queue_free()