class_name WaveSpawner
extends Node2D

signal wave_finished(index: int)
signal all_waves_finished

@export var waves: Array[WaveConfig] = []
@export var wave_delay := 2.0   # float, seconds
@export var autostart := false
@export var target: Node2D

var _elapsed := 0.0
var _current_wave := 0
var _next_spawn_time := 0.0
var _spawned_count := 0
var _started := false

func _ready() -> void:
	if autostart:
		start()

func start() -> void:
	_elapsed = 0.0
	_current_wave = 0
	_next_spawn_time = 0.0
	_spawned_count = 0
	_started = true
	
	# Clear existing enemies
	for child in get_children():
		if child is Enemy:
			child.queue_free()

func _process(delta: float) -> void:
	if not _started:
		return
		
	_elapsed += delta
		
	while _current_wave < waves.size() and _elapsed >= _next_spawn_time:
		# Spawn enemy
		var wave = waves[_current_wave]
		var enemy = wave.enemy_scene.instantiate()
		add_child(enemy)
		
		# Set target if it exists
		if target != null and enemy.has_field("target"):
			enemy.target = target
		
		_spawned_count += 1
		
		# Calculate next spawn time
		var wave_end_time = _next_spawn_time + (wave.count - 1) * wave.interval
		_next_spawn_time = wave_end_time + wave_delay
		
		# Check if this was the last enemy of the current wave
		if _spawned_count >= waves[_current_wave].count:
			wave_finished.emit(_current_wave)
			
			_current_wave += 1
			_spawned_count = 0
			
			# Check if we've finished all waves
			if _current_wave >= waves.size():
				all_waves_finished.emit()
				_started = false
				break
		else:
			# Schedule next enemy in this wave
			_next_spawn_time = _next_spawn_time + wave.interval