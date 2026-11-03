extends GutTest


func test_inventory_empty_start() -> void:
    var inv: Inventory = Inventory.new()
    assert_eq(inv.count(&"coin"), 0)
    assert_eq(inv.count(&"gem"), 0)


func test_inventory_add_and_count() -> void:
    var inv: Inventory = Inventory.new()
    inv.add(&"coin")
    assert_eq(inv.count(&"coin"), 1)
    inv.add(&"coin", 4)
    assert_eq(inv.count(&"coin"), 5)
    assert_eq(inv.count(&"gem"), 0)


func test_inventory_changed_signal_emitted_once_per_add() -> void:
    var inv: Inventory = Inventory.new()
    watch_signals(inv)
    inv.add(&"coin")
    assert_signal_emitted(inv, "changed")
    inv.add(&"coin")
    assert_signal_emitted(inv, "changed")
    assert_signal_count(inv, "changed", 2)
