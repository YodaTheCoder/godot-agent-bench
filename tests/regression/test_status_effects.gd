extends GutTest

var player: Player


func before_each() -> void:
	player = add_child_autofree(load("res://scenes/player.tscn").instantiate())


func _health() -> Health:
	return player.get_node("Health")


func _poison(damage_per_second: float, duration: float) -> Poison:
	var poison := Poison.new()
	poison.damage_per_second = damage_per_second
	poison.duration = duration
	return poison


func _slow(multiplier: float, duration: float) -> Slow:
	var slow := Slow.new()
	slow.multiplier = multiplier
	slow.duration = duration
	return slow


func test_effect_types_and_defaults() -> void:
	var poison := Poison.new()
	var slow := Slow.new()
	assert_is(poison, StatusEffect)
	assert_is(poison, Resource)
	assert_is(slow, StatusEffect)
	assert_is(slow, Resource)
	assert_eq(poison.duration, 1.0)
	assert_eq(poison.damage_per_second, 5.0)
	assert_eq(slow.duration, 1.0)
	assert_eq(slow.multiplier, 0.5)


func test_player_has_status_effects() -> void:
	var node := player.get_node("StatusEffects")
	assert_is(node, StatusEffects)
	assert_eq(player.status_effects, node)
	assert_eq(player.status_effects.active_count(), 0)
	assert_eq(player.effective_speed(), 200.0)


func test_poison_carries_fractional_damage() -> void:
	player.status_effects.add(_poison(5.0, 2.0))
	var expected := [98, 95, 93, 90]
	for health in expected:
		player.status_effects.tick(0.5)
		assert_eq(_health().current, health)
	assert_eq(player.status_effects.active_count(), 0)
	player.status_effects.tick(0.5)
	player.status_effects.tick(0.5)
	assert_eq(_health().current, 90)


func test_poison_is_capped_at_its_duration() -> void:
	player.status_effects.add(_poison(5.0, 2.0))
	player.status_effects.tick(3.0)
	assert_eq(_health().current, 90)
	assert_eq(player.status_effects.active_count(), 0)


func test_poison_apply_tick_directly() -> void:
	_poison(5.0, 1.0).apply_tick(player, 1.0)
	assert_eq(_health().current, 95)


func test_poison_without_health_does_nothing() -> void:
	var node: Node = autofree(Node.new())
	_poison(5.0, 1.0).apply_tick(node, 1.0)
	assert_true(true, "no error raised")


func test_poisons_stack() -> void:
	player.status_effects.add(_poison(5.0, 2.0))
	player.status_effects.add(_poison(5.0, 2.0))
	player.status_effects.tick(1.0)
	assert_eq(_health().current, 90)
	player.status_effects.tick(1.0)
	assert_eq(_health().current, 80)
	player.status_effects.tick(1.0)
	assert_eq(_health().current, 80)


func test_slow_reduces_speed_until_it_expires() -> void:
	player.status_effects.add(_slow(0.5, 1.0))
	assert_eq(player.status_effects.speed_multiplier(), 0.5)
	assert_eq(player.effective_speed(), 100.0)
	player.status_effects.tick(0.5)
	assert_eq(player.effective_speed(), 100.0)
	player.status_effects.tick(0.5)
	assert_eq(player.effective_speed(), 200.0)
	assert_eq(player.status_effects.speed_multiplier(), 1.0)


func test_slows_multiply() -> void:
	player.speed = 300.0
	player.status_effects.add(_slow(0.5, 1.0))
	player.status_effects.add(_slow(0.5, 2.0))
	assert_eq(player.effective_speed(), 75.0)
	player.status_effects.tick(1.0)
	assert_eq(player.effective_speed(), 150.0)


func test_status_effects_on_enemy() -> void:
	var enemy: Enemy = add_child_autofree(load("res://scenes/enemy.tscn").instantiate())
	var effects := StatusEffects.new()
	enemy.add_child(effects)
	effects.add(_poison(4.0, 1.0))
	effects.tick(1.0)
	assert_eq(enemy.get_node("Health").current, 96)
