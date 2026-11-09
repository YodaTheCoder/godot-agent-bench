class_name WaveSpawner
extends Node2D

signal wave_finished(index: int)
signal all_waves_finished

@export var waves: Array[WaveConfig] = []
@export var wave_delay := 2.0
@export var autostart := false
@export var target: Node2D

var _elapsed := 0.0
var _started := false
var _spawning_index := 0

func _ready() -> void:
	if autostart:
		start()

func start() -> void:
	if waves.size() == 0:
		return
	_elapsed = 0.0
	_started = true
	_spawning_index = 0

func _process(delta: float) -> void:
	if not _started:
		return

	_elapsed += delta

	while _spawning_index < get_total_enemies():
		var scheduled_time = get_scheduled_time(_spawning_index)
		if _elapsed >= scheduled_time:
			spawn_enemy(_spawning_index)
			_spawning_index += 1

			if is_last_enemy_of_wave(_spawning_index - 1):
				var wave_idx = get_wave_index(_spawning_index - 1)
				emit_signal("wave_finished", wave_idx)

				if wave_idx == waves.size() - 1:
					emit_signal("all_waves_finished")
					_started = false
		else:
			break

func spawn_enemy(index: int) -> void:
	var wave_idx = get_wave_index(index)
	var wave = waves[wave_idx]
	var enemy_idx = get_enemy_index_in_wave(index)

	var enemy = wave.enemy_scene.instantiate()
	add_child(enemy)
	enemy.global_position = global_position

	if target != null:
		if enemy.has_method("set_target"):
			enemy.target = target

func get_total_enemies() -> int:
	var total := 0
	for wave in waves:
		total += wave.count
	return total

func get_wave_index(enemy_index: int) -> int:
	var count := 0
	for i in range(waves.size()):
		count += waves[i].count
		if enemy_index < count:
			return i
	return waves.size() - 1

func get_enemy_index_in_wave(enemy_index: int) -> int:
	var count := 0
	for i in range(waves.size()):
		var wave = waves[i]
		var end: int = count + wave.count
		if enemy_index < end:
			return enemy_index - count
		count = end
	return 0

func get_scheduled_time(enemy_index: int) -> float:
	var wave_idx := get_wave_index(enemy_index)
	var enemy_idx_in_wave := get_enemy_index_in_wave(enemy_index)
	var wave := waves[wave_idx]

	var base_time := 0.0
	for i in range(wave_idx):
		base_time += (waves[i].count - 1) * waves[i].interval + wave_delay

	base_time += enemy_idx_in_wave * wave.interval
	return base_time

func is_last_enemy_of_wave(enemy_index: int) -> bool:
	var wave_idx := get_wave_index(enemy_index)
	var count := 0
	for i in range(wave_idx):
		count += waves[i].count
	return (count + waves[wave_idx].count - 1) == enemy_index