extends Node2D

@export var max_enemies_on_screen : int = 10
var spawn_timer : Timer

func _ready() -> void:
	if EnemyPoolManager.pools.is_empty():
		await EnemyPoolManager.pool_ready
		
	start_spawner()

func start_spawner() -> void:
	if spawn_timer == null:
		spawn_timer = Timer.new()
		spawn_timer.wait_time = 0.2
		spawn_timer.autostart = true
		spawn_timer.timeout.connect(_on_spawn_timer_timeout)
		add_child(spawn_timer)
	else:
		spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	var active_count = EnemyPoolManager.get_active_enemies().size()
	var space_left = max_enemies_on_screen - active_count
	
	if space_left > 0:
		var spawn_amount = min(space_left, 2) 
		var spawned = EnemyPoolManager.spawn_random_type_enemies(spawn_amount)
		
		if spawned.is_empty():
			pass
