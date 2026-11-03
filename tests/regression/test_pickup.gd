extends GutTest

var pickup: Pickup


func before_each() -> void:
    pickup = add_child_autofree(load("res://scenes/pickup.tscn").instantiate())


func test_pickup_adds_to_player_inventory() -> void:
    var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
    pickup.item_id = &"gem"
    pickup.qty = 3
    pickup._on_body_entered(player)
    assert_eq(player.inventory.count(&"gem"), 3)
    assert_true(pickup.is_queued_for_deletion())


func test_pickup_does_nothing_to_non_player() -> void:
    var static_body: StaticBody2D = add_child_autofree(StaticBody2D.new())
    pickup.item_id = &"coin"
    pickup.qty = 5
    pickup._on_body_entered(static_body)
    assert_eq(pickup.item_id, &"coin")
    assert_eq(pickup.qty, 5)
    assert_false(pickup.is_queued_for_deletion())


func test_pickup_body_entered_signal_works() -> void:
    var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
    pickup.item_id = &"coin"
    pickup.qty = 2
    watch_signals(pickup)
    pickup.body_entered.emit(player)
    assert_signal_emitted(pickup, "body_entered")
    assert_eq(player.inventory.count(&"coin"), 2)
    assert_true(pickup.is_queued_for_deletion())
