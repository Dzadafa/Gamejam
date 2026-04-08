extends Node2D

@onready var bullet_spawn_position = $BulletSpawnPosition
@onready var bullet_target_position = $BulletTargetPosition
@onready var timer = $ReloadTimer


var isShooting : bool = true
var isPressed :bool = false
func _ready() -> void:
	timer.wait_time = 0.25
	
func _physics_process(delta: float) -> void:
	
	
	if Input.is_action_just_pressed("klik_kiri_mouse"):
		shoot()
		
	if Input.is_action_pressed("klik_kiri_mouse") and isShooting:
		shoot()
		
			
	
		
func shoot() -> void:
	var bullet = BulletPoolManager.get_bullet()
	if bullet != null:
		var shoot_direction = (bullet_target_position.global_position - bullet_spawn_position.global_position).normalized()

		isShooting = false
		
		bullet.activate(bullet_spawn_position.global_position, shoot_direction)
		#bullet.bullet_direction = shoot_direction
		bullet.look_at(global_position)
		#bullet.show()
		#bullet.set_physics_process(true)
		
		timer.start()

func _on_timer_timeout() -> void:
	isShooting = true
