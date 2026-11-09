class_name WaveSpawner
extends Node2D

signal wave_finished(index: int)
signal all_waves_finished

@export var waves: Array[WaveConfig] = []
@export var wave_delay := 2.0   # float, seconds
@export var autostart := false
@export var target: Node2D

var _elapsed := 0.0
var _wave_index := -1
var _enemy_spawned_count := 0
var _is_running := false

func _ready() -> void:
	if autostart:
		start()

func start() -> void:
	_elapsed = 0.0
	_wave_index = -1
	_enemy_spawned_count = 0
	_is_running = true
	# Reset all children to ensure clean state
	for child in get_children():
		if child is Enemy:
			child.queue_free()

func _process(delta: float) -> void:
	if not _is_running:
		return
		
	_elapsed += delta
		
	var wave_start_time = 0.0
	var current_wave_config = null
	
	# Process all waves that should be started by now
	while true:
		# Check if we've finished all waves
		if _wave_index >= waves.size() - 1:
			if _enemy_spawned_count > 0: # We still have enemies to spawn from the last wave
				break
			emit_signal("all_waves_finished")
			_is_running = false
			return
		
		# Calculate when the next wave should start
		if _wave_index == -1:
			wave_start_time = 0.0
		else:
			# The time when the last enemy of current wave was scheduled to spawn
			var last_enemy_time = wave_start_time + (waves[_wave_index].count - 1) * waves[_wave_index].interval
			wave_start_time = last_enemy_time + wave_delay
		
		# If we're not ready for the next wave yet, stop processing
		if _elapsed < wave_start_time:
			break
			
		# Start the next wave
		_wave_index += 1
		current_wave_config = waves[_wave_index]
		_enemy_spawned_count = 0

	# Spawn enemies for current wave if we're in a valid wave
	if _wave_index >= 0 and _wave_index < waves.size():
		var total_enemies = current_wave_config.count
		
		# Spawn all enemies that should have been spawned by now
		while _enemy_spawned_count < total_enemies:
			var spawn_time = wave_start_time + _enemy_spawned_count * current_wave_config.interval
			if _elapsed >= spawn_time:
				var enemy = current_wave_config.enemy_scene.instantiate()
				add_child(enemy)
				enemy.position = Vector2.ZERO
				if target != null:
					enemy.target = target
				_enemy_spawned_count += 1
			else:
				break
				
		# Check if this wave is finished (all enemies spawned)
		if _enemy_spawned_count >= total_enemies:
			emit_signal("wave_finished", _wave_index)
			# If we've completed all waves, emit the final signal
			if _wave_index == waves.size() - 1:
				emit_signal("all_waves_finished")
				_is_running = false
