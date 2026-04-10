extends Node2D

@onready var bullet_spawn_position = $BulletSpawnPosition
@onready var bullet_target_position = $BulletTargetPosition
@onready var timer = $ReloadTimer
@onready var animation_gun = $AnimationGun

var isShooting : bool = true
var isScanning: bool = false
var isReloading: bool = false 

const RELOAD_TIME: float = 1.5 

signal on_scan(scan : bool)

func _ready() -> void:
	timer.wait_time = 0.25
	on_scan.connect(BulletPoolManager.get_scanning_gun)
	
func _physics_process(delta: float) -> void:
	if isReloading:
		return
		
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
			shoot()

var n = 0
func shoot() -> void:
	if GameDataManager.current_ammo <= 0:
		reload()
		return
		
	var bullet = BulletPoolManager.get_bullet()
	if bullet != null:
		var shoot_direction = (bullet_target_position.global_position - bullet_spawn_position.global_position).normalized()

		isShooting = false
		GameDataManager.current_ammo -= 1
		
		print("Peluru aktif : " + str(n) + " | Sisa: " + str(GameDataManager.current_ammo))
		n += 1
		
		bullet.activate(bullet_spawn_position.global_position, shoot_direction)
		bullet.look_at(global_position)
		timer.start()
		
		if GameDataManager.current_ammo <= 0:
			reload()

func reload() -> void:
	if isReloading:
		return
		
	isReloading = true
	print("Ammo habis! Auto-reloading...")
	
	
	await get_tree().create_timer(RELOAD_TIME).timeout
	
	GameDataManager.current_ammo = GameDataManager.MAG_SIZE
	isReloading = false
	print("Reload selesai! Ammo kembali 30.")

func _on_gun_hit_flash(knockback: bool) -> void:
	if knockback:
		animation_gun.stop()
		animation_gun.play("hit_flash")
		await animation_gun.animation_finished
	else:
		await animation_gun.animation_finished
		animation_gun.play("RESET")
		
func _on_timer_timeout() -> void:
	isShooting = true
