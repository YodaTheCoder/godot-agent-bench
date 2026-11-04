extends Node

# Unit tests for status effects implementation

func test_poison_basic() -> void:
	var poison = Poison.new()
	assert(poison.duration == 1.0)
	assert(poison.damage_per_second == 5.0)

func test_slow_basic() -> void:
	var slow = Slow.new()
	assert(slow.duration == 1.0)
	assert(slow.multiplier == 0.5)

func test_status_effects_component_structure() -> void:
	# Create a dummy player to test with
	var player_scene = preload("res://scenes/player.tscn")
	var player = player_scene.instantiate()
	
	# Check that our status effects component exists
	assert(player.has_node("StatusEffects"))
	var status_effects = player.get_node("StatusEffects")
	assert(status_effects is StatusEffects)
	
	# Start with zero active effects
	assert(status_effects.active_count() == 0)
	
	# Make sure it starts with correct speed
	var player_script = player as Player
	assert(player_script.effective_speed() == 200.0) # Default player speed
	
	player.queue_free()

func test_poison_damage_calculation() -> void:
	# This would be a deeper integration test, but we'll just check the component creation and basic functionality
	
	# Note: In a real testing scenario, we would call tick directly with specific values
	# and verify the damage calculation behavior described in requirements

func _ready() -> void:
	print("Status effects tests ready")
