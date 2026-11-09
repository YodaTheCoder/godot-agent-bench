# Test script to verify inventory implementation
extends Node

func _ready() -> void:
	_test_inventory()
	_test_player_inventory()
	_test_pickup()
	print("All tests passed!")

func _test_inventory() -> void:
	var inv := Inventory.new()
	assert(inv.count(&"coin") == 0)
	
	inv.add(&"coin")
	inv.add(&"coin", 4)
	assert(inv.count(&"coin") == 5)
	assert(inv.count(&"gem") == 0)
	print("Inventory tests passed!")

func _test_player_inventory() -> void:
	var player_scene := preload("res://scenes/player.tscn")
	var player := player_scene.instantiate()
	add_child(player)
	assert(player.inventory is Inventory)
	assert(player.inventory.count(&"any_item") == 0)
	print("Player inventory tests passed!")

func _test_pickup() -> void:
	var pickup_scene := preload("res://scenes/pickup.tscn")
	var player_scene := preload("res://scenes/player.tscn")
	
	# Test pickup with player
	var pickup := pickup_scene.instantiate()
	pickup.item_id = &"gem"
	pickup.qty = 3
	add_child(pickup)
	
	var player := player_scene.instantiate()
	add_child(player)
	
	# Manually call the body_entered handler
	pickup._on_body_entered(player)
	assert(player.inventory.count(&"gem") == 3)
	assert(pickup.is_queued_for_deletion())
	print("Pickup tests passed!")