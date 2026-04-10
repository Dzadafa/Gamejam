extends Node2D

@export var bullet_scene : PackedScene = preload("res://scenes/bullet.tscn")
@export var pool_size : int = 30

var isScanning :  bool = false
var pool : Array = []

func _ready() -> void:
	for i in range(pool_size):
		var bullet = bullet_scene.instantiate()
		
		if bullet.has_method("deactivate"):
			bullet.deactivate() 
			
		add_child(bullet)
		pool.append(bullet)

func add_to_main_scene(bullet: Node2D) -> void:
	get_tree().current_scene.add_child(bullet)

func get_bullet() -> Node2D:
	for bullet in pool:
		if is_instance_valid(bullet) and not bullet.visible: 
			return bullet
	return null

func get_scanning_gun(scan: bool):
	isScanning = scan
