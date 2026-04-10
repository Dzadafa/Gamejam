extends Node2D

signal pool_ready

@export var enemy_scene : PackedScene = preload("res://scenes/enemy.tscn")
@export var pool_size : int = 2

@export var min_x : float = -1500.0
@export var max_x : float = 1500.0
@export var min_y : float = -1500.0
@export var max_y : float = 1500.0

var pool : Array = [] 

func _ready() -> void:
	create_pool_gradually()

func create_pool_gradually() -> void:
	for i in range(pool_size):
		var enemy = enemy_scene.instantiate()
		
		add_child(enemy)
		enemy.deactivate()
		pool.append(enemy)
		
		if i % 5 == 0:
			await get_tree().process_frame
	pool_ready.emit()

func get_enemy() -> Node2D:
	for enemy in pool:
		if is_instance_valid(enemy) and not enemy.is_physics_processing():
			var random_x = randf_range(min_x, max_x)
			var random_y = randf_range(min_y, max_y)
			
			enemy.activate(Vector2(random_x, random_y))
			return enemy
	return null

func get_active_enemies() -> Array:
	var active_enemies = []
	for enemy in pool: 
		if is_instance_valid(enemy) and enemy.is_physics_processing(): 
			active_enemies.append(enemy)
	return active_enemies
