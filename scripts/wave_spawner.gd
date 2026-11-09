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
var _enemy_index := 0
var _is_running := false
var _last_spawned_wave := -1

func _ready():
	if autostart:
		start()

func start() -> void:
	_elapsed = 0.0
	_wave_index = 0
	_enemy_index = 0
	_is_running = true
	_last_spawned_wave = -1
	# Clear existing enemies
	for child in get_children():
		if child is Enemy:
			child.queue_free()

func _process(delta: float) -> void:
	if not _is_running:
		return
	
	_elapsed += delta
	
	# Spawn enemies for current wave(s)
	while _wave_index < waves.size():
		var wave = waves[_wave_index]
		
		# Calculate the spawn time for the next enemy in this wave
		var spawn_time = _get_wave_start_time(_wave_index) + _enemy_index * wave.interval
		
		# If it's time to spawn an enemy, do so
		if spawn_time <= _elapsed:
			_spawn_enemy(wave)
			
			# Move to the next enemy in this wave
			_enemy_index += 1
			
			# Check if we've finished spawning all enemies for this wave
			if _enemy_index >= wave.count:
				# Emit wave finished signal
				wave_finished.emit(_wave_index)
				
				# Move to the next wave
				_wave_index += 1
				_enemy_index = 0
				
				# Check if we've finished all waves
				if _wave_index >= waves.size():
					all_waves_finished.emit()
					_is_running = false
					return
		else:
			# No more enemies to spawn for now
			break

func _spawn_enemy(wave: WaveConfig) -> void:
	var enemy = wave.enemy_scene.instantiate()
	add_child(enemy)
	
	# Set the target if it exists and has a target property
	if target != null:
		if enemy.has_method("set_target"):
			enemy.set_target(target)
		elif enemy.has_property("target"):
			enemy.target = target

func _get_wave_start_time(wave_index: int) -> float:
	if wave_index <= 0:
		return 0.0
	
	var start_time = 0.0
	for i in range(wave_index):
		var wave = waves[i]
		start_time += (wave.count - 1) * wave.interval + wave_delay
	
	return start_time