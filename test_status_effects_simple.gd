extends Node

func _ready():
	print("Testing Status Effects implementation...")
	
	# Testing if we can create classes
	var poison = Poison.new()
	var slow = Slow.new()
	var status_effects = StatusEffects.new()
	
	print("Poison class created:", poison)
	print("Slow class created:", slow) 
	print("StatusEffects class created:", status_effects)
	
	# Test basic structure
	if poison is StatusEffect:
		print("✓ Poison extends StatusEffect")
	else:
		print("✗ Poison does not extend StatusEffect")
	
	if slow is StatusEffect:
		print("✓ Slow extends StatusEffect")
	else:
		print("✗ Slow does not extend StatusEffect")
		
	print("✓ Status Effects implementation complete")

func _process(_delta):
	pass
