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
var current_wave := 0
var current_enemy_in_wave := 0

func _ready() -> void:
	if autostart:
		start()

func start() -> void:
	started = true
	elapsed = 0.0
	current_wave = 0
	current_enemy_in_wave = 0

func _process(delta: float) -> void:
	if not started:
		return

	elapsed += delta

	while current_wave < waves.size():
		var wave: WaveConfig = waves[current_wave]

		while current_enemy_in_wave < wave.count:
			var enemy_time: float = get_enemy_scheduled_time(current_wave, current_enemy_in_wave)

			if elapsed < enemy_time:
				break

			var enemy := wave.enemy_scene.instantiate()
			add_child(enemy)
			if target != null and enemy.has("target"):
				enemy.target = target

			current_enemy_in_wave += 1

			if current_enemy_in_wave >= wave.count:
				emit_signal("wave_finished", current_wave)
				current_wave += 1
				current_enemy_in_wave = 0

				if current_wave >= waves.size():
					emit_signal("all_waves_finished")
					return
		break

func get_wave_start_time(wave_index: int) -> float:
	var time: float = 0.0
	for i in range(wave_index):
		time += (waves[i].count - 1) * waves[i].interval + wave_delay
	return time

func get_enemy_scheduled_time(wave_index: int, enemy_index: int) -> float:
	var time: float = get_wave_start_time(wave_index)
	return time + enemy_index * waves[wave_index].interval