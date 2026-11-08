extends GutTest

func test_inventory_count() -> void:
	var inv: Inventory = Inventory.new()
	assert_eq(inv.count(&"coin"), 0)

func test_inventory_add_multiple() -> void:
	var inv: Inventory = Inventory.new()
	inv.add(&"coin")
	inv.add(&"coin", 4)
	assert_eq(inv.count(&"coin"), 5)
	assert_eq(inv.count(&"gem"), 0)

func test_inventory_empty_counts_zero() -> void:
	var inv: Inventory = Inventory.new()
	assert_eq(inv.count(&"coin"), 0)
	assert_eq(inv.count(&"gem"), 0)

func test_pickup_can_be_instantiated() -> void:
	var scene: PackedScene = load("res://scenes/pickup.tscn")
	assert_is(scene, PackedScene)
	var pickup: Area2D = scene.instantiate()
	assert_is(pickup, Area2D)

func test_pickup_collects_for_player() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var pickup: Area2D = load("res://scenes/pickup.tscn").instantiate()
	add_child_autofree(pickup)
	pickup.item_id = &"gem"
	pickup.qty = 3
	pickup._on_body_entered(player)
	assert_eq(player.inventory.count(&"gem"), 3)
	assert_true(pickup.is_queued_for_deletion())

func test_pickup_does_not_collect_for_non_player() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var pickup: Area2D = load("res://scenes/pickup.tscn").instantiate()
	add_child_autofree(pickup)
	pickup.item_id = &"gem"
	pickup.qty = 3
	var static_body := StaticBody2D.new()
	add_child_autofree(static_body)
	pickup._on_body_entered(static_body)
	assert_eq(player.inventory.count(&"gem"), 0)
	assert_false(pickup.is_queued_for_deletion())
