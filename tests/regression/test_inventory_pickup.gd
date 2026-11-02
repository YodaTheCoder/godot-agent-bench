extends GutTest

func test_inventory_logic() -> void:
	var inv = Inventory.new()
	assert_eq(inv.count(&"coin"), 0)
	inv.add(&"coin", 1)
	assert_eq(inv.count(&"coin"), 1)
	inv.add(&"coin", 4)
	assert_eq(inv.count(&"coin"), 5)
	assert_eq(inv.count(&"gem"), 0)

func test_pickup_logic() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var pickup = load("res://scenes/pickup.tscn").instantiate()
	add_child(pickup)
	
	pickup.item_id = &"gem"
	pickup.qty = 3
	
	# Simulate body entry
	pickup._on_body_entered(player)
	
	assert_eq(player.inventory.count(&"gem"), 3)
	assert(pickup.is_queued_for_deletion())

func test_pickup_ignores_non_player() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var static_body = StaticBody2D.new()
	add_child(static_body)
	
	var pickup = load("res://scenes/pickup.tscn").instantiate()
	add_child(pickup)
	pickup.item_id = &"gem"
	pickup.qty = 3
	
	pickup._on_body_entered(static_body)
	
	assert_eq(player.inventory.count(&"gem"), 0)
	assert(!pickup.is_queued_for_deletion())
