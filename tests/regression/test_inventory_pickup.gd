extends GutTest

func test_inventory_initialization() -> void:
	var inv = Inventory.new()
	assert_eq(inv.count(&"coin"), 0)

func test_inventory_add_and_count() -> void:
	var inv = Inventory.new()
	inv.add(&"coin", 1)
	assert_eq(inv.count(&"coin"), 1)
	inv.add(&"coin", 4)
	assert_eq(inv.count(&"coin"), 5)
	assert_eq(inv.count(&"gem"), 0)

func test_inventory_emits_changed() -> void:
	var inv = Inventory.new()
	var signals_emitted = 0
	inv.changed.connect(func(): signals_emitted += 1)
	
	inv.add(&"coin", 1)
	assert_eq(signals_emitted, 1)
	inv.add(&"coin", 1)
	assert_eq(signals_emitted, 2)

func test_player_has_inventory() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	assert_not_null(player.inventory)
	assert_eq(player.inventory.count(&"any"), 0)

func test_pickup_player_interaction() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var pickup = load("res://scenes/pickup.tscn").instantiate()
	add_child(pickup)
	pickup.item_id = &"gem"
	pickup.qty = 3
	
	# Manually trigger the callback to simulate signal
	pickup._on_body_entered(player)
	
	assert_eq(player.inventory.count(&"gem"), 3)
	assert(pickup.is_queued_for_deletion())

func test_pickup_non_player_interaction() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var pickup = load("res://scenes/pickup.tscn").instantiate()
	add_child(pickup)
	pickup.item_id = &"gem"
	pickup.qty = 3
	
	# Create a dummy body (StaticBody2D)
	var static_body = StaticBody2D.new()
	add_child(static_body)
	
	pickup._on_body_entered(static_body)
	
	assert_eq(player.inventory.count(&"im_not_a_player"), 0)
	assert(not pickup.is_queued_for_deletion())
	
	static_body.free()
