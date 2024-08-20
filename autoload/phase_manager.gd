extends Node

var spawners : Array[SpawnComponent] = []
var build_phase := true

var adventurers_spawned : int = 0
var adventurers_alive: int:
	get: return _adventurers_alive
	set(value):
		if (value == _adventurers_alive): return
		if (value == 0 and _adventurers_alive > 0):
			adventurers_per_wave += increase_per_wave
			start_build_phase()
		_adventurers_alive = value
	
var _adventurers_alive: int = 0

var adventurers_per_wave := 4
var increase_per_wave := 2

var build_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	build_timer = Timer.new()
	build_timer.wait_time = 10
	build_timer.autostart = false
	build_timer.one_shot = true
	
	build_timer.timeout.connect(_on_attack_phase)
	add_child(build_timer)

func start_build_phase() -> void:
	adventurers_alive = 0
	adventurers_spawned = 0
	
	build_phase = true
	build_timer.start()

func _on_attack_phase() -> void:
	build_phase = false
	
	for i : int in adventurers_per_wave:
		var spawner : SpawnComponent = spawners.pick_random()
		spawner.spawn()
		
		NavigationGlobals.navigation_region.bake_navigation_polygon()
		await get_tree().create_timer(1).timeout
