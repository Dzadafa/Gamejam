extends Node2D

@export var bullet_scene : PackedScene
@onready var bullet_spawn = $BulletSpawn
@onready var bullet_target = $BulletTarget
@onready var timer = $ReloadTimer
var isShooting : bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = 0.25
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("klik_kiri_mouse"):
		if isShooting:
			shoot()
	if Input.is_action_just_pressed("klik_kiri_mouse"):
		shoot()
	pass
	
func shoot():   
	var bullet = bullet_scene.instantiate()
	var shoot_direction = (bullet_target.global_position - bullet_spawn.global_position).normalized()
	
	isShooting = false
	get_tree().current_scene.add_child(bullet)
	
	bullet.global_position = bullet_spawn.global_position
	bullet.bullet_direction = shoot_direction
	bullet.look_at(global_position)
	timer.start()

func _on_timer_timeout() -> void:
	isShooting = true
	pass # Replace with function body.
