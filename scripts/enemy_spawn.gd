extends Node2D

@export var max_enemies_on_screen : int = 20 
var spawn_timer : Timer

func _ready() -> void:
	await EnemyPoolManager.pool_ready
	start_spawner()

func start_spawner() -> void:
	spawn_timer = Timer.new()
	spawn_timer.wait_time = 0.5
	spawn_timer.autostart = true
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(spawn_timer)

func _on_spawn_timer_timeout() -> void:
	var active_enemies_count = EnemyPoolManager.get_active_enemies().size()
	if active_enemies_count < max_enemies_on_screen:
		var enemy = EnemyPoolManager.get_enemy()
		#if enemy == null:
			#print("semua musuh dipakai di layar!")
