extends GutTest


func _make_player() -> Player:
	return add_child_autofree(load("res://scenes/player.tscn").instantiate())


func _poison(dps: float, seconds: float) -> Poison:
	var effect := Poison.new()
	effect.damage_per_second = dps
	effect.duration = seconds
	return effect


func _slow(multiplier: float, seconds: float) -> Slow:
	var effect := Slow.new()
	effect.multiplier = multiplier
	effect.duration = seconds
	return effect


func test_defaults_and_types() -> void:
	var poison := Poison.new()
	var slow := Slow.new()
	assert_is(poison, StatusEffect)
	assert_is(slow, StatusEffect)
	assert_is(poison, Resource)
	assert_almost_eq(StatusEffect.new().duration, 1.0, 0.0001)
	assert_almost_eq(poison.damage_per_second, 5.0, 0.0001)
	assert_almost_eq(slow.multiplier, 0.5, 0.0001)
	var player := _make_player()
	assert_is(player.get_node("StatusEffects"), StatusEffects)
	assert_eq(player.status_effects, player.get_node("StatusEffects"))
	assert_eq(player.status_effects.active_count(), 0)
	assert_almost_eq(player.effective_speed(), 200.0, 0.0001)


func test_poison_deals_damage_over_its_duration_then_stops() -> void:
	var player := _make_player()
	var health: Health = player.get_node("Health")
	player.status_effects.add(_poison(5.0, 2.0))
	assert_eq(player.status_effects.active_count(), 1)
	var seen := []
	for _i in 4:
		player.status_effects.tick(0.5)
		seen.append(health.current)
	assert_eq(seen, [98, 95, 93, 90], "fractional damage carries over")
	assert_eq(player.status_effects.active_count(), 0, "expired at exactly 2 s")
	player.status_effects.tick(0.5)
	player.status_effects.tick(0.5)
	assert_eq(health.current, 90, "no damage after expiry")


func test_long_tick_is_capped_at_remaining_duration() -> void:
	var player := _make_player()
	var health: Health = player.get_node("Health")
	player.status_effects.add(_poison(5.0, 2.0))
	player.status_effects.tick(3.0)
	assert_eq(health.current, 90)
	assert_eq(player.status_effects.active_count(), 0)


func test_poison_apply_tick_damages_targets_health() -> void:
	var player := _make_player()
	var health: Health = player.get_node("Health")
	_poison(5.0, 2.0).apply_tick(player, 1.0)
	assert_eq(health.current, 95)


func test_stacking_two_poisons_adds_damage() -> void:
	var player := _make_player()
	var health: Health = player.get_node("Health")
	player.status_effects.add(_poison(5.0, 2.0))
	player.status_effects.add(_poison(5.0, 2.0))
	player.status_effects.tick(1.0)
	assert_eq(health.current, 90)
	player.status_effects.tick(1.0)
	assert_eq(health.current, 80)
	player.status_effects.tick(1.0)
	assert_eq(health.current, 80)


func test_slow_halves_effective_speed_then_expires() -> void:
	var player := _make_player()
	player.status_effects.add(_slow(0.5, 1.0))
	assert_almost_eq(player.status_effects.speed_multiplier(), 0.5, 0.0001)
	assert_almost_eq(player.effective_speed(), 100.0, 0.0001)
	player.status_effects.tick(0.5)
	assert_almost_eq(player.effective_speed(), 100.0, 0.0001, "still slowed at 0.5 s")
	player.status_effects.tick(0.5)
	assert_almost_eq(player.effective_speed(), 200.0, 0.0001, "expired at exactly 1 s")
	assert_almost_eq(player.status_effects.speed_multiplier(), 1.0, 0.0001)


func test_two_slows_multiply() -> void:
	var player := _make_player()
	player.speed = 300.0
	player.status_effects.add(_slow(0.5, 1.0))
	player.status_effects.add(_slow(0.5, 2.0))
	assert_almost_eq(player.effective_speed(), 75.0, 0.0001)
	player.status_effects.tick(1.0)
	assert_almost_eq(player.effective_speed(), 150.0, 0.0001, "first slow expired")


func test_component_acts_on_its_parent() -> void:
	var enemy: Enemy = add_child_autofree(load("res://scenes/enemy.tscn").instantiate())
	var effects := StatusEffects.new()
	enemy.add_child(effects)
	effects.add(_poison(4.0, 1.0))
	effects.tick(1.0)
	assert_eq((enemy.get_node("Health") as Health).current, 96)
