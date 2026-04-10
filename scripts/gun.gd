extends Node2D


@onready var bullet_spawn_position = $BulletSpawnPosition
@onready var bullet_target_position = $BulletTargetPosition
@onready var timer = $ReloadTimer
@onready var animation_gun = $AnimationGun

var isShooting : bool = true
var isPressed :bool = false
var isScanning: bool = false

signal on_scan(scan : bool)

func _ready() -> void:
	timer.wait_time = 0.25
	on_scan.connect(BulletPoolManager.get_scanning_gun)
	
func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("klik_kiri_mouse"):
		isScanning = false
		on_scan.emit(isScanning)
		
	if Input.is_action_just_pressed("klik_kanan_mouse"):
		isScanning = true
		on_scan.emit(isScanning)
	
	if not isScanning:
		if Input.is_action_just_pressed("klik_kiri_mouse"):
			shoot()
			
		if Input.is_action_pressed("klik_kiri_mouse") and isShooting:
			shoot()
			
	else:
		if Input.is_action_pressed("klik_kanan_mouse") and isShooting:
			print("scan")
			print(isScanning)
			shoot()
		
			
	
var n = 0
func shoot() -> void:
	var bullet = BulletPoolManager.get_bullet()
	if bullet != null:
		var shoot_direction = (bullet_target_position.global_position - bullet_spawn_position.global_position).normalized()

		isShooting = false
		print("peluru aktif : " + str(n))
		n += 1
		bullet.activate(bullet_spawn_position.global_position, shoot_direction)
		bullet.look_at(global_position)
		timer.start()

func _on_gun_hit_flash(knockback: bool) -> void:
	if knockback:
		animation_gun.play("hit_flash")
	else:
		animation_gun.play("RESET") 
		
func _on_timer_timeout() -> void:
	isShooting = true
