extends Node2D

@onready var bullet_spawn_position = $BulletSpawnPosition
@onready var bullet_target_position = $BulletTargetPosition
@onready var timer = $ReloadTimer
@onready var animation_gun = $AnimationGun
@onready var click_particle = $ClickParticleMouse
@onready var gun_sprite = $CanvasGroup/Gun
@onready var vacuum_particle = $VacuumParticle

var shoot_gun = preload("res://assets/player/gun.png") 
var ray_gun = preload("res://assets/player/ray_gun.png") 


var isShooting : bool = true
var isScanning: bool = false
var isReloading: bool = false 

const RELOAD_TIME: float = 1.5 

signal on_scan(scan : bool)
signal reload_status(is_reloading : bool)

func _ready() -> void:
	timer.wait_time = 0.25
	on_scan.connect(BulletPoolManager.get_scanning_gun)
	gun_sprite.texture = shoot_gun
	vacuum_particle.emitting = false
	
func _physics_process(delta: float) -> void:
	if isReloading:
		vacuum_particle.emitting = false
		return
		
	var is_anybody_chasing = GameDataManager.chasing_count > 0
	
	if is_anybody_chasing:
		if Input.is_action_just_pressed("switch_weapon"):
			isScanning = not isScanning
			on_scan.emit(isScanning)
	else:
		if isScanning:
			isScanning = false
			on_scan.emit(isScanning)
			print("Shoot Gun")
		if Input.is_action_just_pressed("switch_weapon"):
			print("tolong aku, aku butuh medkit")
	if not isScanning:
		gun_sprite.texture = shoot_gun
		vacuum_particle.emitting = false
		if Input.is_action_just_pressed("klik_kiri_mouse"):
			spawn_particle()
			shoot()
	else:
		gun_sprite.texture = ray_gun
		if Input.is_action_pressed("klik_kiri_mouse"):
			var offset_to_mouse = get_global_mouse_position() - bullet_spawn_position.global_position
			var mat = vacuum_particle.process_material as ParticleProcessMaterial
			if mat:
				mat.emission_shape_offset = Vector3(offset_to_mouse.x, offset_to_mouse.y, 0)
			vacuum_particle.emitting = true
			if isShooting:
				spawn_particle()
				shoot()
		else:
			vacuum_particle.emitting = false

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
	print("ada ammo lagi ngga bang? oh ada")
	
	reload_status.emit(true) 
	
	await get_tree().create_timer(RELOAD_TIME).timeout
	
	GameDataManager.current_ammo = GameDataManager.MAG_SIZE
	isReloading = false
	print("ammo kembali 30")
	
	reload_status.emit(false)

func _on_gun_hit_flash(knockback: bool) -> void:
	if knockback:
		animation_gun.stop()
		animation_gun.play("hit_flash")
		await animation_gun.animation_finished
	else:
		await animation_gun.animation_finished
		animation_gun.play("RESET")
		
func spawn_particle():
	click_particle.global_position = get_global_mouse_position()
	click_particle.restart()
	click_particle.one_shot = true
	#click_particle.emitting = true
	
func _on_timer_timeout() -> void:
	isShooting = true
