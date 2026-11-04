extends GutTest

# Test Poison and Slow resources
func test_poison_is_status_effect_and_resource() -> void:
	var poison = Poison.new()
	assert_is(poison, StatusEffect)
	assert_is(poison, Resource)


func test_slow_is_status_effect_and_resource() -> void:
	var slow = Slow.new()
	assert_is(slow, StatusEffect)
	assert_is(slow, Resource)


func test_poison_default_values() -> void:
	var poison = Poison.new()
	assert_eq(poison.duration, 1.0)
	assert_eq(poison.damage_per_second, 5.0)


func test_slow_default_values() -> void:
	var slow = Slow.new()
	assert_eq(slow.duration, 1.0)
	assert_eq(slow.multiplier, 0.5)


func test_status_effects_node_on_player() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	assert_is(player.get_node("StatusEffects"), StatusEffects)
	assert_is(player.status_effects, StatusEffects)


func test_player_status_effects_starts_empty() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	assert_eq(player.status_effects.active_count(), 0)


func test_player_effective_speed_default() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	assert_eq(player.effective_speed(), 200.0)
