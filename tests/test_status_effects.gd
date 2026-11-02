extends Node

# Test script to verify all acceptance criteria for status effects implementation

func _ready() -> void:
	test_status_effect_resources()
	test_player_status_effects_component()
	test_poison_damage_calculation()
	test_multiple_poisons()
	test_slow_effect()
	test_enemy_status_effects()
	print("All tests passed!")

func test_status_effect_resources() -> void:
	# 1. Poison and Slow are StatusEffect resources with correct default values
	var poison := Poison.new()
	assert(poison is StatusEffect, "Poison should extend StatusEffect")
	assert(poison.duration == 1.0, "Poison default duration should be 1.0")
	assert(poison.damage_per_second == 5.0, "Poison default damage per second should be 5.0")
	
	var slow := Slow.new()
	assert(slow is StatusEffect, "Slow should extend StatusEffect")
	assert(slow.duration == 1.0, "Slow default duration should be 1.0")
	assert(slow.multiplier == 0.5, "Slow default multiplier should be 0.5")
	print("✓ Status effect resources test passed")

func test_player_status_effects_component() -> void:
	# 2. Player has StatusEffects component with correct initial state
	var player := Player.new()
	assert(player.has_node("StatusEffects"), "Player should have StatusEffects node")
	
	var status_effects = player.get_node("StatusEffects")
	assert(status_effects is StatusEffects, "StatusEffects should be a StatusEffects component")
	assert(status_effects.active_effects.size() == 0, "Initial active effects should be empty")
	print("✓ Player status effects component test passed")

func test_poison_damage_calculation() -> void:
	# 3. Poison damage calculation works correctly (including fractional damage handling)
	var player := Player.new()
	var health = Health.new()
	health.max_health = 100
	health.current = 100
	player.add_child(health)
	health.name = "Health"
	
	var poison := Poison.new()
	poison.damage_per_second = 5.0
	
	# Test with 1 second delta (should deal 5 damage)
	poison.apply_tick(player, 1.0)
	assert(health.current == 95, "Should have taken 5 damage")
	
	# Test with 0.3 seconds delta (should deal 1 damage, 0.5 remaining)
	var poison2 := Poison.new()
	poison2.damage_per_second = 5.0
	poison2.apply_tick(player, 0.3)
	assert(health.current == 94, "Should have taken 1 more damage")
	
	# Test that fractional damage accumulates
	var poison3 := Poison.new()
	poison3.damage_per_second = 10.0
	poison3.apply_tick(player, 0.6)
	poison3.apply_tick(player, 0.6)
	assert(health.current == 84, "Should have taken 12 damage (1.2 + 1.2 = 2.4, rounded to 2, then 2 * 6 = 12)")
	print("✓ Poison damage calculation test passed")

func test_multiple_poisons() -> void:
	# 4. Multiple poisons work correctly
	var player := Player.new()
	var health = Health.new()
	health.max_health = 100
	health.current = 100
	player.add_child(health)
	health.name = "Health"
	
	var poison1 := Poison.new()
	poison1.damage_per_second = 5.0
	var poison2 := Poison.new()
	poison2.damage_per_second = 3.0
	
	# Apply tick multiple times with different poisons
	poison1.apply_tick(player, 0.5)
	poison2.apply_tick(player, 0.5)
	
	# Each poison should deal damage independently
	assert(health.current == 87, "Should have taken 8 damage total (5 + 3)")
	print("✓ Multiple poisons test passed")

func test_slow_effect() -> void:
	# 5. Slow effect works correctly with speed calculation
	var player := Player.new()
	player.speed = 100.0
	
	var slow1 := Slow.new()
	slow1.multiplier = 0.5
	
	var slow2 := Slow.new()
	slow2.multiplier = 0.8
	
	# Test speed multiplier calculation
	var status_effects = player.get_node("StatusEffects")
	status_effects.add(slow1)
	assert(status_effects.speed_multiplier() == 0.5, "Speed multiplier should be 0.5")
	
	status_effects.add(slow2)
	assert(status_effects.speed_multiplier() == 0.4, "Speed multiplier should be 0.4 (0.5 * 0.8)")
	print("✓ Slow effect test passed")

func test_enemy_status_effects() -> void:
	# 6. Enemy status effects also work
	var enemy := Player.new()  # Using Player as a base class for enemies
	enemy.name = "Enemy"
	
	# Create an enemy with health and status effects
	var health = Health.new()
	health.max_health = 100
	health.current = 100
	enemy.add_child(health)
	health.name = "Health"
	
	var poison := Poison.new()
	poison.damage_per_second = 2.0
	
	var status_effects = enemy.get_node("StatusEffects")
	assert(status_effects is StatusEffects, "Enemy should have StatusEffects component")
	
	# Apply a poison effect to enemy
	status_effects.add(poison)
	
	# Create a mock tick to test damage application to enemy
	poison.apply_tick(enemy, 1.0)
	assert(health.current == 98, "Enemy should take 2 damage from poison")
	print("✓ Enemy status effects test passed")