extends GutTest

var initial_count = 0

func before_each() -> void:
    pass


func test_inventory_resource_exists() -> void:
    assert_file_exists("res://scripts/inventory.gd")
    var inv: Inventory = Inventory.new()
    assert_not_null(inv)


func test_inventory_is_resource() -> void:
    assert_true(Inventory.new().is_class(Resource))


func test_inventory_count_initial_zero() -> void:
    var inv: Inventory = Inventory.new()
    assert_eq(inv.count(&"coin"), 0)
    assert_eq(inv.count(&"gem"), 0)


func test_inventory_add_coin_once() -> Void:
    var inv: Inventory = Inventory.new()
    inv.add(&"coin")
    assert_eq(inv.count(&"coin"), 1)


func test_inventory_add_multiple_coins() -> void:
    var inv: Inventory = Inventory.new()
    inv.add(&"coin")
    inv.add(&"coin", 4)
    assert_eq(inv.count(&"coin"), 5)


func test_inventory_independent_items() -> void:
    var inv: Inventory = Inventory.new()
    inv.add(&"coin")
    inv.add(&"gem")
    assert_eq(inv.count(&"coin"), 1)
    assert_eq(inv.count(&"gem"), 1)


func test_inventory_changed_emitted_once_per_add() -> void:
    var inv: Inventory = Inventory.new()
    watch_signals(inv)
    inv.add(&"coin")
    assert_signal_emitted(inv, "changed")
    assert_signal_count(inv, "changed", 1)
    inv.add(&"coin")
    assert_signal_emitted(inv, "changed")
    assert_signal_count(inv, "changed", 2)
    inv.add(&"gem")
    assert_signal_count(inv, "changed", 3)
