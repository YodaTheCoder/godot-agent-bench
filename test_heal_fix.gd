extends GutTest

func test_overheal_clamped_to_max_health() -> void:
	var health: Health = Health.new()
	health.max_health = 100
	add_child_autofree(health)
	
	health.damage(10) # health is now 90
	health.heal(50)   # would make 140, should be clamped to 100
	assert_eq(health.current, 100)

func test_at_full_health_heal_doesnt_exceed_max() -> void:
	var health: Health = Health.new()
	health.max_health = 100
	add_child_autofree(health)
	
	# Start at full health
	health.damage(0)  # health is 100
	health.heal(25)   # would make 125, should be clamped to 100
	assert_eq(health.current, 100)

func test_different_max_health() -> void:
	var health: Health = Health.new()
	health.max_health = 40
	add_child_autofree(health)
	
	health.damage(10) # health is now 30
	health.heal(100)  # would make 130, should be clamped to 40
	assert_eq(health.current, 40)

func test_heal_does_nothing_when_dead() -> void:
	var health: Health = Health.new()
	health.max_health = 100
	add_child_autofree(health)
	
	health.damage(100) # dies
	assert_eq(health.current, 0)
	health.heal(20)    # should do nothing
	assert_eq(health.current, 0)

func test_normal_healing_below_max_still_works() -> void:
	var health: Health = Health.new()
	health.max_health = 100
	add_child_autofree(health)
	
	health.damage(50)  # health is now 50
	health.heal(20)    # should make 70
	assert_eq(health.current, 70)