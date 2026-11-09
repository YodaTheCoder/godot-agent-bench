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
var _is_finished := false

func _ready() -> void:
	if autostart:
		start()

func start() -> void:
	_elapsed = 0.0
	_wave_index = 0
	_enemy_index = 0
	_is_finished = false

func _process(delta: float) -> void:
	if _wave_index < 0 or _is_finished:
		return
	
	_elapsed += delta
	
	while _wave_index < waves.size():
		# Calculate the scheduled time for the next enemy to spawn in current wave
		var wave_start_time = 0.0
		for i in range(_wave_index):
			wave_start_time += (waves[i].count - 1) * waves[i].interval + wave_delay
		
		var spawn_time = wave_start_time + _enemy_index * waves[_wave_index].interval
		
		if _elapsed >= spawn_time:
			# Spawn enemy
			var enemy = waves[_wave_index].enemy_scene.instantiate()
			add_child(enemy)
			enemy.position = Vector2.ZERO
			if target != null and "target" in enemy:
				enemy.target = target
			
			_enemy_index += 1
			
			# Check if we've finished the current wave
			if _enemy_index >= waves[_wave_index].count:
				emit_signal("wave_finished", _wave_index)
				
				if _wave_index == waves.size() - 1:
					emit_signal("all_waves_finished")
					_is_finished = true
					break
				else:
					# Move to next wave
					_wave_index += 1
					_enemy_index = 0
		else:
			# No more enemies to spawn from this wave yet
			break