class_name WaveSpawner
extends Node2D

signal wave_finished(index: int)
signal all_waves_finished

@export var waves: Array[WaveConfig] = []
@export var wave_delay := 2.0   # float, seconds
@export var autostart := false
@export var target: Node2D

var elapsed := 0.0
var is_started := false
var wave_start_times: Array[float] = []
var enemy_scheduled_times: Array[float] = []
var next_enemy_to_spawn_index := 0
var next_wave_index := 0

func _ready():
	if autostart:
		start()

func start() -> void:
	elapsed = 0.0
	is_started = true
	next_enemy_to_spawn_index = 0
	next_wave_index = 0
	wave_start_times.clear()
	enemy_scheduled_times.clear()
	
	# Pre-calculate all enemy scheduled times
	_calculate_all_enemy_times()
	
	# Clear any existing enemies
	for child in get_children():
		if child is Enemy:
			child.queue_free()

func _process(delta: float) -> void:
	if not is_started:
		return
	
	elapsed += delta
	
	# Spawn as many enemies as needed for elapsed time
	var enemies_spawned = false
	while next_enemy_to_spawn_index < enemy_scheduled_times.size():
		if enemy_scheduled_times[next_enemy_to_spawn_index] <= elapsed:
			_spawn_enemy(next_wave_index)
			enemies_spawned = true
			next_enemy_to_spawn_index += 1
			
			# Check if we just finished a wave
			if next_enemy_to_spawn_index >= waves[next_wave_index].count:
				wave_finished.emit(next_wave_index)
				# Move to next wave
				next_wave_index += 1
				# Check if all waves are done
				if next_wave_index >= waves.size():
					all_waves_finished.emit()
					is_started = false
					return
		else:
			break

func _calculate_all_enemy_times():
	wave_start_times.clear()
	enemy_scheduled_times.clear()
	
	# Calculate the start time of each wave
	var current_time = 0.0
	for i in range(waves.size()):
		wave_start_times.append(current_time)
		
		# Schedule each enemy in this wave
		for j in range(waves[i].count):
			var scheduled_time = current_time + j * waves[i].interval
			enemy_scheduled_times.append(scheduled_time)
			
		# Update for next wave (if there is one)
		if i < waves.size() - 1:
			current_time += (waves[i].count - 1) * waves[i].interval + wave_delay

func _spawn_enemy(wave_index: int) -> void:
	var new_enemy = waves[wave_index].enemy_scene.instantiate()
	add_child(new_enemy)
	new_enemy.position = Vector2.ZERO
	if target != null and "target" in new_enemy:
		new_enemy.target = target