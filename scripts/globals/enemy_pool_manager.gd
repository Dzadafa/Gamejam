extends Node2D

@export var enemy_scene : PackedScene = preload("res://scenes/enemy.tscn")
@export var pool_size : int = 30

@export var min_x : float = -500.0
@export var max_x : float = 500.0
@export var min_y : float = -500.0
@export var max_y : float = 500.0

var pool : Array = [] 
var last_scene = null

func _ready() -> void:
	get_tree().tree_changed.connect(_on_tree_changed)
	call_deferred("prepare_enemy_pool")
	
	for i in range(pool_size):
		var enemy = enemy_scene.instantiate()
		call_deferred("add_to_main_scene", enemy)
		enemy.call_deferred("deactivate")
		pool.append(enemy)

func add_to_main_scene(enemy: Node2D) -> void:
	get_tree().current_scene.add_child(enemy)

func get_enemy() -> Node2D:
	for enemy in pool:
		if is_instance_valid(enemy) and not enemy.is_physics_processing():
			var random_x = randf_range(min_x, max_x)
			var random_y = randf_range(min_y, max_y)
			
			enemy.activate(Vector2(random_x, random_y))
			#enemy.activate(Vector2(200, 200))
			return enemy
	return null

func deactivate_enemy(enemy: Node2D) -> void:
	enemy.hide()
	enemy.set_physics_process(false)

func activate_enemy(enemy: Node2D) -> void:
	enemy.show()
	enemy.set_physics_process(true)

func get_active_enemies() -> Array:
	var active_enemies = []
	for enemy in pool: 
		if enemy.is_physics_processing(): 
			active_enemies.append(enemy)
	return active_enemies

func _on_tree_changed():
	var tree = get_tree()
	if tree == null: return
	
	var current_scene = get_tree().current_scene
	if current_scene != null and current_scene != last_scene:
		last_scene = current_scene
		
		refill_enemy_pool()

func prepare_enemy_pool():
	if get_tree() == null or get_tree().current_scene == null:
		return
	pool.clear()
	for i in range(pool_size):
		var enemy = enemy_scene.instantiate()
		
		get_tree().current_scene.call_deferred("add_child", enemy)
		
		if enemy.has_method("deactivate"):
			enemy.call_deferred("deactivate")
			
		pool.append(enemy)

func refill_enemy_pool():
	prepare_enemy_pool()
