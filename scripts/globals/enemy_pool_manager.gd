extends Node2D

signal pool_ready

var enemy_scenes : Array[PackedScene] = [
	preload("res://scenes/dino-ing.tscn"),
	preload("res://scenes/moon-shine.tscn"),
	preload("res://scenes/enemy.tscn"),
	preload("res://scenes/blue-ging.tscn"),
	preload("res://scenes/passive-3-eyed.tscn"),
	preload("res://scenes/snusy.tscn"),
]
var aggressive_types : Array[int] = []
var passive_types : Array[int] = []

var pool_size_per_type : int = 10

@export var min_x : float = -100.0
@export var max_x : float = 1000.0
@export var min_y : float = -1000.0
@export var max_y : float = 1000.0
@export var safe_spawn: float = 300.0

var pools : Dictionary = {}

func _ready() -> void:
	create_pool_gradually()

func create_pool_gradually() -> void:
	for type_index in range(enemy_scenes.size()):
		var scene = enemy_scenes[type_index]
		pools[type_index] = [] 
		
		for i in range(pool_size_per_type):
			var enemy = scene.instantiate()
			
			if i == 0:
				if enemy.behavior == enemy.Behavior.PASSIVE:
					passive_types.append(type_index)
				else:
					aggressive_types.append(type_index)
					
			add_child(enemy)
			enemy.deactivate()
			pools[type_index].append(enemy)
			
			if i % 5 == 0:
				await get_tree().process_frame
				
	pool_ready.emit()

func get_enemy(type_index: int) -> Node2D:
	if not pools.has(type_index):
		return null
	for enemy in pools[type_index]:
		if is_instance_valid(enemy) and not enemy.is_physics_processing():
			var safe_spawn_pos = get_valid_spawn_position()
			enemy.activate(safe_spawn_pos)
			return enemy
	return null

func get_active_enemies() -> Array:
	var active_enemies = []
	for enemy_array in pools.values(): 
		for enemy in enemy_array: 
			if is_instance_valid(enemy) and enemy.is_physics_processing(): 
				active_enemies.append(enemy)
				
	return active_enemies
	
func spawn_multiple_enemies(type_index: int, amount: int) -> Array:
	var spawned_enemies = []
	
	for i in range(amount):
		var enemy = get_enemy(type_index)
		
		if enemy != null:
			spawned_enemies.append(enemy)
		else:
			break
			
	return spawned_enemies

func spawn_random_type_enemies(amount: int) -> Array:
	var spawned_enemies = []
	
	for i in range(amount):
		var random_type_index = randi() % enemy_scenes.size()
		var enemy = get_enemy(random_type_index)
		
		if enemy != null:
			spawned_enemies.append(enemy)
		else:
			pass
			
	return spawned_enemies

func spawn_random_aggressive(amount: int) -> Array:
	if aggressive_types.is_empty(): return []
	
	var spawned_enemies = []
	for i in range(amount):
		var random_type_index = aggressive_types[randi() % aggressive_types.size()]
		var enemy = get_enemy(random_type_index)
		
		if enemy != null: spawned_enemies.append(enemy)
	return spawned_enemies

func spawn_random_passive(amount: int) -> Array:
	if passive_types.is_empty(): return []
	
	var spawned_enemies = []
	for i in range(amount):
		var random_type_index = passive_types[randi() % passive_types.size()]
		var enemy = get_enemy(random_type_index)
		
		if enemy != null: spawned_enemies.append(enemy)
	return spawned_enemies

func get_valid_spawn_position() -> Vector2:
	var random_position = Vector2.ZERO
	var is_valid = false
	var max_attempts = 10 
	
	for attempt in range(max_attempts):
		random_position = Vector2(randf_range(min_x, max_x), randf_range(min_y, max_y))
		
		if PlayerManager.is_player_alive():
			var player_position = PlayerManager.player.global_position
			var distance = random_position.distance_to(player_position)
			
			if distance >= safe_spawn:
				is_valid = true
				break
		else:
			is_valid = true
			break
	return random_position
