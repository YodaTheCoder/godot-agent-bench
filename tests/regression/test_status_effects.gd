extends GutTest

func before_each() -> void:
	ScoreManager.reset()

func after_each() -> void:
	ScoreManager.reset()

func test_status_effect_defaults() -> void:
	var poison = Poison.new()
	assert_eq(poison.duration, 1.0)
	assert_eq(poison.damage_per_second, 5.0)
	
	var slow = Slow.new()
	assert_eq(slow.duration, 1.0)
	assert_eq(slow.multiplier, 0.5)

func test_player_has_status_effects() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	assert_is(player.get_node("StatusEffects"), StatusEffects)
	assert_eq(player.status_effects, player.get_node("StatusEffects"))

func test_effective_speed_initial() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	assert_eq(player.effective_speed(), 200.0)
	assert_eq(player.status_effects.active_count(), 0)

func test_poison_tick_basic() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	poison.duration = 2.0
	
	player.status_effects.add(poison)
	assert_eq(player.status_effects.active_count(), 1)
	
	player.status_effects.tick(1.0)
	assert_eq(player.get_node("Health").current, 95)

func test_poison_fractional_damage() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	poison.duration = 2.0
	
	player.status_effects.add(poison)
	
	# tick(0.5) four times (total 2 seconds)
	player.status_effects.tick(0.5)
	assert_eq(player.get_node("Health").current, 98)
	player.status_effects.tick(0.5)
	assert_eq(player.get_node("Health").current, 95)
	player.status_effects.tick(0.5)
	assert_eq(player.get_node("Health").current, 93)
	player.status_effects.tick(0.5)
	assert_eq(player.get_node("Health").current, 90)
	assert_eq(player.status_effects.active_count(), 0)

func test_poison_big_tick() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var poison = Poison.new()
	poison.damage_per_second = 5.0
	poison.duration = 2.0
	
	player.status_effects.add(poison)
	player.status_effects.tick(3.0)
	
	# Should deal exactly 10 damage (5 * 2 seconds)
	assert_eq(player.get_node("Health").current, 90)
	assert_eq(player.status_effects.active_count(), 0)

func test_two_poisons() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var poison1 = Poison.new()
	poison1.damage_per_second = 5.0
	poison1.duration = 2.0
	var poison2 = Poison.new()
	poison2.damage_per_second = 5.0
	poison2.duration = 2.0
	
	player.status_effects.add(poison1)
	player.status_effects.add(poison2)
	assert_eq(player.status_effects.active_count(), 2)
	
	# Each deals 5 damage per second, so both together deal 10 damage per second
	player.status_effects.tick(1.0)
	assert_eq(player.get_node("Health").current, 90)
	
	player.status_effects.tick(1.0)
	assert_eq(player.get_node("Health").current, 80)
	
	player.status_effects.tick(1.0)
	assert_eq(player.get_node("Health").current, 80)  # Both poisons expire
	assert_eq(player.status_effects.active_count(), 0)

func test_slow_speed_multiplier() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var slow = Slow.new()
	
	player.status_effects.add(slow)
	assert_eq(player.status_effects.speed_multiplier(), 0.5)
	assert_eq(player.effective_speed(), 100.0)

func test_slow_expiry() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var slow = Slow.new()
	slow.duration = 1.0
	
	player.status_effects.add(slow)
	player.status_effects.tick(0.5)
	assert_eq(player.effective_speed(), 100.0)
	
	player.status_effects.tick(0.5)
	assert_eq(player.effective_speed(), 200.0)
	assert_eq(player.status_effects.speed_multiplier(), 1.0)

func test_multiple_slows_multiply() -> void:
	var player: Player = add_child_autofree(load("res://scenes/player.tscn").instantiate())
	var slow1 = Slow.new()
	slow1.duration = 1.0
	var slow2 = Slow.new()
	slow2.duration = 2.0
	
	# Set speed to 300 for clear visibility
	player.speed = 300.0
	
	player.status_effects.add(slow1)
	player.status_effects.add(slow2)
	assert_eq(player.status_effects.active_count(), 2)
	assert_eq(player.effective_speed(), 75.0)  # 300 * 0.5 * 0.5
	
	player.status_effects.tick(1.0)
	assert_eq(player.effective_speed(), 150.0)  # slow1 expires, 300 * 0.5 = 150
	assert_eq(player.status_effects.speed_multiplier(), 0.5)

func test_poison_on_enemy() -> void:
	var enemy: Enemy = add_child_autofree(load("res://scenes/enemy.tscn").instantiate())
	var poison = Poison.new()
	poison.damage_per_second = 4.0
	poison.duration = 1.0
	
	enemy.get_node("StatusEffects").add(poison)
	enemy.get_node("StatusEffects").tick(1.0)
	
	assert_eq(enemy.get_node("Health").current, 96)
