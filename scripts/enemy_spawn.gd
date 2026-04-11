extends Node2D

@export var max_enemies_on_screen : int = 10
var spawn_timer : Timer

func _ready() -> void:
	await EnemyPoolManager.pool_ready
	start_spawner()

func start_spawner() -> void:
	spawn_timer = Timer.new()
	spawn_timer.wait_time = 0.2
	spawn_timer.autostart = true
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(spawn_timer)

func _on_spawn_timer_timeout() -> void:
	var active_enemies_count = EnemyPoolManager.get_active_enemies().size()
	
	var active_count = EnemyPoolManager.get_active_enemies().size()
	var space_left = max_enemies_on_screen - active_count
	
	if space_left > 0:
			EnemyPoolManager.spawn_random_type_enemies(space_left)
			
	if active_enemies_count < max_enemies_on_screen:
		var spawned = EnemyPoolManager.spawn_random_type_enemies(2)
		if spawned.is_empty():
			print("semua tipe di layar!")
