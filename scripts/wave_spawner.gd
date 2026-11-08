class_name WaveSpawner
extends Node2D

signal wave_finished(index: int)
signal all_waves_finished

@export var waves: Array[WaveConfig] = []
@export var wave_delay := 2.0
@export var autostart := false
@export var target: Node2D

var elapsed := 0.0
var started := false
var wave_start_times: Array[float] = []
var next_enemy_to_spawn := 0

func _ready() -> void:
	if autostart:
		start()

func start() -> void:
	started = true
	elapsed = 0.0
	next_enemy_to_spawn = 0
	calculate_wave_start_times()

func calculate_wave_start_times() -> void:
	wave_start_times.clear()
	var current_time := 0.0
	for i in range(waves.size()):
		wave_start_times.append(current_time)
		var wave = waves[i]
		if i > 0:
			var prev_wave = waves[i - 1]
			var prev_last_time = wave_start_times[i - 1] + (prev_wave.count - 1) * prev_wave.interval
			current_time = prev_last_time + wave_delay

func _process(delta: float) -> void:
	if not started:
		return

	elapsed += delta

	while next_enemy_to_spawn < total_enemies():
		var wave_index = get_wave_index_for_enemy(next_enemy_to_spawn)
		if wave_index >= waves.size():
			break

		var wave = waves[wave_index]
		var enemy_index_in_wave = get_enemy_index_in_wave(next_enemy_to_spawn)
		var scheduled_time = wave_start_times[wave_index] + enemy_index_in_wave * wave.interval

		if elapsed >= scheduled_time:
			spawn_enemy(wave)
			next_enemy_to_spawn += 1

			var current_wave_index = get_wave_index_for_enemy(next_enemy_to_spawn - 1)
			var next_wave_index = get_wave_index_for_enemy(next_enemy_to_spawn)
			if next_wave_index > current_wave_index or next_enemy_to_spawn >= total_enemies():
				emit_signal("wave_finished", current_wave_index)
				if current_wave_index == waves.size() - 1:
					emit_signal("all_waves_finished")
					return
		else:
			break

func spawn_enemy(wave: WaveConfig) -> void:
	var enemy = wave.enemy_scene.instantiate()
	add_child(enemy)
	if target != null and enemy.has_method("set_target"):
		enemy.set_target(target)

func total_enemies() -> int:
	var total := 0
	for wave in waves:
		total += wave.count
	return total

func get_wave_index_for_enemy(enemy_idx: int) -> int:
	var accumulated := 0
	for i in range(waves.size()):
		accumulated += waves[i].count
		if enemy_idx < accumulated:
			return i
	return waves.size()

func get_enemy_index_in_wave(enemy_idx: int) -> int:
	var accumulated := 0
	for i in range(waves.size()):
		var count = waves[i].count
		if enemy_idx < accumulated + count:
			return enemy_idx - accumulated
		accumulated += count
	return 0