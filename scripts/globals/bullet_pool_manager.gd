extends Node2D

@export var bullet_scene : PackedScene = preload("res://scenes/bullet.tscn")
@export var pool_size : int = 30

var pool : Array = []

func _ready() -> void:
	for i in range(pool_size):
		var bullet = bullet_scene.instantiate()
		
		deactivate_bullet(bullet)
		
		call_deferred("add_to_main_scene", bullet)
		pool.append(bullet)

func add_to_main_scene(bullet: Node2D) -> void:
	get_tree().current_scene.add_child(bullet)

func get_bullet() -> Node2D:
	for bullet in pool:
		if not bullet.visible: 
			return bullet
	return null

func deactivate_bullet(bullet: Node2D) -> void:
	bullet.hide()
	bullet.set_physics_process(false)
