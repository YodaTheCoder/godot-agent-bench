class_name WaveSpawner
extends Node2D

signal wave_finished(index: int)
signal all_waves_finished

@export var waves: Array[WaveConfig] = []
@export var wave_delay := 2.0   # float, seconds
@export var autostart := false
@export var target: Node2D

var _current_wave_index := -1
var _elapsed := 0.0
var _wave_start_time := 0.0
var _enemies_spawned_in_current_wave := 0

func _ready() -> void:
	if autostart:
		start()

func start() -> void:
	_current_wave_index = 0
	_elapsed = 0.0
	_wave_start_time = 0.0
	_enemies_spawned_in_current_wave = 0

func _process(delta: float) -> void:
	if _current_wave_index >= waves.size():
		return
		
	_elapsed += delta
	
	var current_wave = waves[_current_wave_index]
	
	while true:
		# Calculate next scheduled spawn time for the current wave
		var spawn_time = _wave_start_time + _enemies_spawned_in_current_wave * current_wave.interval
		
		if _elapsed < spawn_time:
			break
			
		# Spawn enemy
		var enemy = current_wave.enemy_scene.instantiate()
		add_child(enemy)
		
		if target != null and enemy.has_method("set_target"):
			enemy.set_target(target)
		elif target != null and enemy has "target":
			enemy.target = target
			
		_enemies_spawned_in_current_wave += 1
		
		# Check if wave is finished
		if _enemies_spawned_in_current_wave >= current_wave.count:
			wave_finished.emit(_current_wave_index)
			
			# Move to next wave if available
			if _current_wave_index < waves.size() - 1:
				_current_wave_index += 1
				_wave_start_time = spawn_time + current_wave.interval + wave_delay
				_enemies_spawned_in_current_wave = 0
			else:
				all_waves_finished.emit()
				return