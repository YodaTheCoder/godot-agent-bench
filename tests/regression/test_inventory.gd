extends GutTest

var emit_count: int

func _reset_emit_count() -> void:
	emit_count = 0

func test_inventory_new_has_zero_count() -> void:
	assert_eq(Inventory.new().count(&"coin"), 0)

func test_inventory_add_increments_count() -> void:
	var inv := Inventory.new()
	inv.add(&"coin")
	inv.add(&"coin", 4)
	assert_eq(inv.count(&"coin"), 5)
	assert_eq(inv.count(&"gem"), 0)

func test_inventory_emits_changed_once_per_add() -> void:
	var inv := Inventory.new()
	_reset_emit_count()
	inv.connect("changed", Callable(self, "_on_inventory_changed"))
	inv.add(&"coin")
	inv.add(&"gem", 2)
	assert_eq(emit_count, 2)

func _on_inventory_changed() -> void:
	emit_count += 1

func test_player_has_inventory() -> void:
	var player := Player.new()
	assert_not_null(player.inventory)
	assert_eq(player.inventory.count(&"coin"), 0)
	player.queue_free()