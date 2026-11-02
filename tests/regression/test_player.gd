extends GutTest

func test_inventory_logic() -> void:
	var inv = Inventory.new()
	assert_eq(inv.count(&"coin"), 0)
	inv.add(&"coin")
	assert_eq(inv.count(&"coin"), 1)
	inv.add(&"coin", 4)
	assert_eq(inv.count(&"coin"), 5)
	assert_eq(inv.count(&"gem"), 0)

func test_pickup_mechanism() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var pickup = add_child_autofree(load("res://scenes/pickup.tscn").instantiate())
	pickup.item_id = &"gem"
	pickup.qty = 3
	
	# Manually trigger the signal to simulate collision
	pickup.body_entered.emit(player)
	
	assert_eq(player.inventory.count(&"gem"), 3)
	assert(pickup.is_queued_for_deletion())

func test_pickup_ignores_non_player() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var pickup = add_child_autofree(load("res://scenes/pickup.tscn").instantiate())
	pickup.item_id = &"gem"
	pickup.qty = 3
	
	var static_body = StaticBody2D.new()
	add_child(static_body)
	
	pickup.body_entered.emit(static_body)
	
	assert_eq(player.inventory.count(&"gem"), 0)
	assert(!pickup.is_queued_for_deletion())
	static_body.free()
