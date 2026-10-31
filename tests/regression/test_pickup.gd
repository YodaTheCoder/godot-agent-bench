extends GutTest

var _player: Player
var _pickup: Area2D


func before_each() -> void:
	_player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	_pickup = load("res://scenes/pickup.tscn").instantiate()
	_pickup.item_id = &"gem"
	_pickup.qty = 3
	add_child_autofree(_pickup)


func test_player_collects_pickup() -> void:
	_pickup._on_body_entered(_player)
	assert_eq(_player.inventory.count(&"gem"), 3)
	assert_true(_pickup.is_queued_for_deletion())


func test_body_entered_signal_collects_pickup() -> void:
	_pickup.body_entered.emit(_player)
	assert_eq(_player.inventory.count(&"gem"), 3)
	assert_true(_pickup.is_queued_for_deletion())


func test_non_player_body_is_ignored() -> void:
	var wall: StaticBody2D = add_child_autofree(StaticBody2D.new())
	_pickup._on_body_entered(wall)
	assert_false(_pickup.is_queued_for_deletion())
	assert_eq(_player.inventory.count(&"gem"), 0)
