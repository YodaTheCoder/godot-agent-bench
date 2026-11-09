extends Node

func _ready() -> void:
	var health = Health.new()
	health.max_health = 100
	add_child(health)
	
	var damaged_emitted = []
	var died_emitted = false
	
	# Connect to signals
	health.connect("damaged", func(amount, remaining):
		damaged_emitted.append({"amount": amount, "remaining": remaining})
	)
	health.connect("died", func():
		died_emitted = true
	)
	
	# Test 1: At 100/100, damage(30) emits damaged(30, 70) exactly once
	health.damage(30)
	assert_eq(damaged_emitted.size(), 1)
	assert_eq(damaged_emitted[0]["amount"], 30)
	assert_eq(damaged_emitted[0]["remaining"], 70)
	
	# Test 2: damage(30) then damage(20) emits damaged twice, second time with (20, 50)
	damaged_emitted.clear()
	health.damage(30)
	health.damage(20)
	assert_eq(damaged_emitted.size(), 2)
	assert_eq(damaged_emitted[1]["amount"], 20)
	assert_eq(damaged_emitted[1]["remaining"], 50)
	
	# Test 3: damage(0) does not emit damaged
	damaged_emitted.clear()
	health.damage(0)
	assert_eq(damaged_emitted.size(), 0)
	
	# Test 4: At 100/100, damage(150) emits damaged(100, 0), then died
	damaged_emitted.clear()
	died_emitted = false
	health.damage(150)
	assert_eq(damaged_emitted.size(), 1)
	assert_eq(damaged_emitted[0]["amount"], 100)
	assert_eq(damaged_emitted[0]["remaining"], 0)
	assert_eq(died_emitted, true)
	
	# Test 5: After death, a further damage(10) does not emit damaged
	damaged_emitted.clear()
	health.damage(10)
	assert_eq(damaged_emitted.size(), 0)
	
	print("All tests passed!")

func _process(_delta: float) -> void:
	# This is just to keep the node alive for testing
	pass