extends GutTest

const ENEMY_SCENE := "res://scenes/enemy.tscn"

var events: Array = []


func before_each() -> void:
	events = []


func _wave(count: int, interval: float) -> WaveConfig:
	var wave := WaveConfig.new()
	wave.enemy_scene = load(ENEMY_SCENE)
	wave.count = count
	wave.interval = interval
	return wave


## Wave 0: 3 enemies 0.5 s apart; wave 1: 2 enemies 0.25 s apart; 1.0 s between waves.
func _make_spawner() -> WaveSpawner:
	var spawner := WaveSpawner.new()
	spawner.waves.append(_wave(3, 0.5))
	spawner.waves.append(_wave(2, 0.25))
	spawner.wave_delay = 1.0
	add_child_autofree(spawner)
	spawner.wave_finished.connect(func(index: int) -> void:
		events.append("wave_finished %d at %d" % [index, _enemy_count(spawner)]))
	spawner.all_waves_finished.connect(func() -> void:
		events.append("all_waves_finished at %d" % _enemy_count(spawner)))
	return spawner


func _enemy_count(spawner: Node) -> int:
	var n := 0
	for child in spawner.get_children():
		if child is Enemy:
			n += 1
	return n


func test_wave_config_defaults() -> void:
	var wave := WaveConfig.new()
	assert_is(wave, Resource)
	assert_null(wave.enemy_scene)
	assert_eq(wave.count, 1)
	assert_almost_eq(wave.interval, 1.0, 0.0001)
	var spawner: WaveSpawner = autofree(WaveSpawner.new())
	assert_is(spawner, Node2D)
	assert_almost_eq(spawner.wave_delay, 2.0, 0.0001)
	assert_eq(spawner.waves.size(), 0)


func test_nothing_spawns_before_start() -> void:
	var spawner := _make_spawner()
	spawner._process(5.0)
	assert_eq(_enemy_count(spawner), 0)
	assert_eq(events, [])


func test_start_itself_spawns_nothing() -> void:
	var spawner := _make_spawner()
	spawner.start()
	assert_eq(_enemy_count(spawner), 0)


func test_spawn_timeline_with_fixed_steps() -> void:
	var spawner := _make_spawner()
	spawner.start()
	# Enemy count after each _process(0.25) call; elapsed = 0.25, 0.5, ... 2.5.
	var counts := []
	for _i in 10:
		spawner._process(0.25)
		counts.append(_enemy_count(spawner))
	assert_eq(counts, [1, 2, 2, 3, 3, 3, 3, 4, 5, 5])


func test_signals_fire_in_order_after_last_spawn_of_each_wave() -> void:
	var spawner := _make_spawner()
	spawner.start()
	var fired_at := {}
	for step in 12:
		var before := events.size()
		spawner._process(0.25)
		if events.size() > before:
			fired_at[step + 1] = events.slice(before)
	assert_eq(events, ["wave_finished 0 at 3", "wave_finished 1 at 5", "all_waves_finished at 5"])
	assert_eq(fired_at, {
		4: ["wave_finished 0 at 3"],
		9: ["wave_finished 1 at 5", "all_waves_finished at 5"],
	})


func test_large_delta_spawns_everything_in_one_call() -> void:
	var spawner := _make_spawner()
	spawner.start()
	spawner._process(10.0)
	assert_eq(_enemy_count(spawner), 5)
	assert_eq(events, ["wave_finished 0 at 3", "wave_finished 1 at 5", "all_waves_finished at 5"])
	spawner._process(10.0)
	assert_eq(_enemy_count(spawner), 5, "nothing more after the last wave")
	assert_eq(events.size(), 3, "no further signals")


func test_main_scene_has_configured_wave_spawner() -> void:
	var main: Node = autofree(load("res://scenes/main.tscn").instantiate())
	var spawners := []
	var stack: Array[Node] = [main]
	while not stack.is_empty():
		var node: Node = stack.pop_back()
		if node is WaveSpawner:
			spawners.append(node)
		stack.append_array(node.get_children())
	assert_eq(spawners.size(), 1, "exactly one WaveSpawner in main.tscn")
	if spawners.is_empty():
		return
	var spawner: WaveSpawner = spawners[0]
	assert_gt(spawner.waves.size(), 0)
	for wave in spawner.waves:
		assert_not_null(wave.enemy_scene)
		assert_gt(wave.count, 0)
