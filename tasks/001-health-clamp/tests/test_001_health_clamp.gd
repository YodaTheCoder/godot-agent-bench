extends GutTest


func _make_health(max_hp: int) -> Health:
	var health := Health.new()
	health.max_health = max_hp
	add_child_autofree(health)
	return health


func test_heal_past_max_clamps_to_max() -> void:
	var health := _make_health(100)
	health.damage(10)
	health.heal(50)
	assert_eq(health.current, 100)


func test_heal_at_full_health_stays_at_max() -> void:
	var health := _make_health(100)
	health.heal(25)
	assert_eq(health.current, 100)


func test_clamp_uses_custom_max_health() -> void:
	var health := _make_health(40)
	health.damage(10)
	health.heal(100)
	assert_eq(health.current, 40)


func test_heal_when_dead_does_nothing() -> void:
	var health := _make_health(100)
	health.damage(100)
	health.heal(20)
	assert_eq(health.current, 0)


func test_heal_below_max_still_heals() -> void:
	var health := _make_health(100)
	health.damage(50)
	health.heal(20)
	assert_eq(health.current, 70)
