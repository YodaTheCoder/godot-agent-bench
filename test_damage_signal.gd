# Test script to verify the damage signal implementation
extends Node

func _ready() -> void:
	print("Testing Health damaged signal implementation")
	
	# Create a health instance
	var health = Health.new()
	health.max_health = 100
	add_child(health)
	
	# Test 1: At 100/100, damage(30) should emit damaged(30, 70)
	print("Test 1: damage(30) from 100/100")
	var damaged_emitted = false
	var damage_amount = 0
	var remaining_health = 0
	
	health.connect("damaged", func(amount, remaining):
		damaged_emitted = true
		damage_amount = amount
		remaining_health = remaining
		print("  Damaged signal emitted with amount: ", amount, ", remaining: ", remaining)
	)
	
	health.damage(30)
	
	if damaged_emitted and damage_amount == 30 and remaining_health == 70:
		print("  ✅ Test 1 passed")
	else:
		print("  ❌ Test 1 failed")
	
	# Reset
	damaged_emitted = false
	damage_amount = 0
	remaining_health = 0
	
	# Test 2: damage(30) then damage(20) should emit damaged twice
	print("Test 2: damage(30) then damage(20)")
	var damage_count = 0
	
	health.connect("damaged", func(amount, remaining):
		damage_count += 1
		print("  Damaged signal emitted (", damage_count, ") with amount: ", amount, ", remaining: ", remaining)
	)
	
	health.damage(20)
	
	if damage_count == 2 and damage_amount == 20 and remaining_health == 50:
		print("  ✅ Test 2 passed")
	else:
		print("  ❌ Test 2 failed")
	
	# Test 3: damage(0) should not emit damaged
	print("Test 3: damage(0)")
	damaged_emitted = false
	
	health.connect("damaged", func(amount, remaining):
		damaged_emitted = true
		print("  Damaged signal emitted with amount: ", amount, ", remaining: ", remaining)
	)
	
	health.damage(0)
	
	if not damaged_emitted:
		print("  ✅ Test 3 passed")
	else:
		print("  ❌ Test 3 failed")
	
	print("Test completed")

func _process(_delta: float) -> void:
	pass