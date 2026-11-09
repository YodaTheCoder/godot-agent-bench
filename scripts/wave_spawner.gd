class_name WaveSpawner
extends Node2D

signal wave_finished(index: int)
signal all_waves_finished

@export var waves: Array[WaveConfig] = []
@export var wave_delay := 2.0   # float, seconds
@export var autostart := false
@export var target: Node2D

var _wave_index := -1
var _elapsed := 0.0
var _spawn_schedule := []
var _next_spawn_index := 0

func start() -> void:
	_wave_index = 0
	_elapsed = 0.0
	_next_spawn_index = 0
	
	# Precompute all spawn times for all enemies in all waves
	_spawn_schedule.clear()
	var current_time = 0.0
	
	for wave_index in range(waves.size()):
		var wave = waves[wave_index]
		for enemy_index in range(wave.count):
			_spawn_schedule.append([current_time, wave_index])
			current_time += wave.interval
		# Schedule next wave to start after the last enemy of this wave finishes
		if wave_index < waves.size() - 1:  # Not the last wave
			current_time += wave_delay

func _ready() -> void:
	if autostart:
		start()

func _process(delta: float) -> void:
	if _wave_index < 0:
		return
	
	_elapsed += delta
	
	var previous_wave_idx = -1
	
	# Process all scheduled spawns that should happen by now
	while _next_spawn_index < _spawn_schedule.size():
		var entry = _spawn_schedule[_next_spawn_index]
		var spawn_time = entry[0]
		var wave_index = entry[1]
		
		if spawn_time > _elapsed:
			break
			
		# Spawn the enemy
		var wave = waves[wave_index]
		var enemy = wave.enemy_scene.instantiate()
		add_child(enemy)
		
		# Set target if exists
		if target and enemy.has_field("target"):
			enemy.target = target
		
		previous_wave_idx = wave_index
		_next_spawn_index += 1
	
	# Check for completed waves
	if previous_wave_idx != -1:
		# If we just processed enemies from a wave, check if this wave is now complete
		# A wave is complete when the next spawn time is not from the same wave
		var should_emit_signal = false
		var wave_to_emit = -1
		
		if _next_spawn_index >= _spawn_schedule.size():
			# We've processed all enemies, so emit for this final wave
			wave_to_emit = previous_wave_idx
			should_emit_signal = true
		elif _spawn_schedule[_next_spawn_index][1] != previous_wave_idx:
			# Next spawn is from a different wave - so we just finished the previous wave
			wave_to_emit = previous_wave_idx
			should_emit_signal = true
		
		if should_emit_signal:
			wave_finished.emit(wave_to_emit)
			
			# If this was the last wave, emit all_waves_finished
			if wave_to_emit == waves.size() - 1:
				all_waves_finished.emit()
				_wave_index = -1