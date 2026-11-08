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
var _spawn_times: Array[float] = []

func _ready() -> void:
	if autostart:
		start()

func start() -> void:
	_wave_index = 0
	_elapsed = 0.0
	_spawn_times.clear()
	
	# Pre-calculate exact spawn times according to timing rules:
	# - wave i starts at time Si = sum of (previous waves' total enemies * interval + wave_delay) 
	# - enemy k (0-based) in wave i spawns at Si + k * waves[i].interval
	var current_time = 0.0
	for i in range(waves.size()):
		var wave = waves[i]
		for j in range(wave.count):
			_spawn_times.append(current_time + j * wave.interval)
		
		# Schedule when next wave starts (after the last enemy of this wave) 
		if i < waves.size() - 1:
			current_time = _spawn_times[_spawn_times.size() - 1] + wave_delay

func _process(delta: float) -> void:
	if _wave_index < 0:
		return
	
	_elapsed += delta
	
	# Process all enemy spawns that should happen by now
	while _wave_index < _spawn_times.size() and _elapsed >= _spawn_times[_wave_index]:
		_spawn_enemy()
		
func _spawn_enemy() -> void:
	if _wave_index >= _spawn_times.size():
		return
		
	var wave_config = waves[_get_wave_index_for_spawner_index(_wave_index)]
	
	# Create the enemy
	var enemy = wave_config.enemy_scene.instantiate()
	add_child(enemy)
	
	# Set target if we have one and the enemy supports it
	if target != null and "target" in enemy:
		enemy.target = target
	
	# Check if we completed a whole wave
	var total_in_waves_up_to_current = 0
	var current_wave_index = 0
	for i in range(waves.size()):
		total_in_waves_up_to_current += waves[i].count
		if _wave_index < total_in_waves_up_to_current:
			current_wave_index = i
			break
	
	# Check if this is the last enemy of wave_index
	var enemies_in_previous_waves = 0
	for i in range(current_wave_index):
		enemies_in_previous_waves += waves[i].count
		
	if _wave_index == total_in_waves_up_to_current - 1:
		# This was last enemy of its wave, emit the signal
		emit_signal("wave_finished", current_wave_index)
		
		# Check if this was also the final wave
		if current_wave_index == waves.size() - 1:
			emit_signal("all_waves_finished")
			_wave_index = -1  # Prevent further processing
		else:
			_wave_index += 1
	else:
		_wave_index += 1

func _get_wave_index_for_spawner_index(index: int) -> int:
	var count = 0
	for i in range(waves.size()):
		count += waves[i].count
		if index < count:
			return i
	return waves.size() - 1