extends GutTest

func test_status_effect_defaults() -> void:
	var poison := Poison.new()
	assert_eq(poison.duration, 1.0)
	assert_eq(poison.damage_per_second, 5.0)


func test_slow_defaults() -> void:
	var slow := Slow.new()
	assert_eq(slow.duration, 1.0)
	assert_eq(slow.multiplier, 0.5)


func test_player_starts_with_no_effects() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	assert_eq(player.status_effects.active_count(), 0)
	assert_almost_eq(player.effective_speed(), 200.0, 0.001)


func test_poison_damage_over_time() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var poison := Poison.new()
	poison.damage_per_second = 5.0
	poison.duration = 2.0
	player.status_effects.add(poison)
	assert_eq(player.status_effects.active_count(), 1)
	player.status_effects.tick(0.5)
	assert_eq(player.get_node("Health").current, 98)
	player.status_effects.tick(0.5)
	assert_eq(player.get_node("Health").current, 95)
	player.status_effects.tick(0.5)
	assert_eq(player.get_node("Health").current, 93)
	player.status_effects.tick(0.5)
	assert_eq(player.get_node("Health").current, 90)
	assert_eq(player.status_effects.active_count(), 0)


func test_poison_tick_larger_than_duration() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var poison := Poison.new()
	poison.damage_per_second = 5.0
	poison.duration = 2.0
	player.status_effects.add(poison)
	player.status_effects.tick(3.0)
	assert_eq(player.get_node("Health").current, 90)
	assert_eq(player.status_effects.active_count(), 0)


func test_poison_apply_tick_direct() -> void:
	var player: Node = Node.new()
	var health := Health.new()
	health.max_health = 100
	health.current = 100
	health.name = "Health"
	player.add_child(health)
	var poison := Poison.new()
	poison.damage_per_second = 5.0
	poison.apply_tick(player, 1.0)
	assert_eq(health.current, 95)


func test_two_poisons_stack() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var poison1 := Poison.new()
	poison1.damage_per_second = 5.0
	poison1.duration = 2.0
	var poison2 := Poison.new()
	poison2.damage_per_second = 5.0
	poison2.duration = 2.0
	player.status_effects.add(poison1)
	player.status_effects.add(poison2)
	assert_eq(player.status_effects.active_count(), 2)
	player.status_effects.tick(1.0)
	assert_eq(player.get_node("Health").current, 90)
	player.status_effects.tick(1.0)
	assert_eq(player.get_node("Health").current, 80)
	player.status_effects.tick(1.0)
	assert_eq(player.get_node("Health").current, 80)


func test_slow_reduces_speed() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	assert_almost_eq(player.effective_speed(), 200.0, 0.001)
	var slow := Slow.new()
	slow.duration = 1.0
	slow.multiplier = 0.5
	player.status_effects.add(slow)
	assert_almost_eq(player.effective_speed(), 100.0, 0.001)
	player.status_effects.tick(0.5)
	assert_almost_eq(player.effective_speed(), 100.0, 0.001)
	player.status_effects.tick(0.5)
	assert_almost_eq(player.effective_speed(), 200.0, 0.001)
	assert_eq(player.status_effects.speed_multiplier(), 1.0)


func test_multiple_slows_multiply() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	player.speed = 300.0
	var slow1 := Slow.new()
	slow1.duration = 1.0
	slow1.multiplier = 0.5
	var slow2 := Slow.new()
	slow2.duration = 2.0
	slow2.multiplier = 0.5
	player.status_effects.add(slow1)
	player.status_effects.add(slow2)
	assert_almost_eq(player.effective_speed(), 75.0, 0.001)
	player.status_effects.tick(1.0)
	assert_almost_eq(player.effective_speed(), 150.0, 0.001)


func test_poison_on_enemy() -> void:
	var enemy: Enemy = add_child_autofree(load("res://scenes/enemy.tscn").instantiate())
	var status_effects := StatusEffects.new()
	enemy.add_child(status_effects)
	var poison := Poison.new()
	poison.damage_per_second = 4.0
	poison.duration = 1.0
	status_effects.add(poison)
	status_effects.tick(1.0)
	assert_eq(enemy.get_node("Health").current, 96)