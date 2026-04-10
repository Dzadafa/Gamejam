extends CharacterBody2D
class_name Player

signal on_hit_flash(knockback : bool)

const SPEED = 400.0
const ACCELERATION = SPEED * 5
const FRICTION = SPEED * 4
var knockback = GameDataManager.KNOCKBACK

@export var bullet_scene : PackedScene
@onready var gun_marker = $GunPivot
@onready var gun = $GunPivot/Gun
@onready var player_body = $Body
@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer

var knockback_multiplier : float
var isKnockbacked = false
var isMoving = true
var is_animation_hurt = null

func _ready() -> void:
	z_index = 2
	#mendaftarkan diri sebagaii player
	PlayerManager.player = self
	SignalBus.enemy_hit.connect(_knockback)
	
	on_hit_flash.connect(gun._on_gun_hit_flash)
	on_hit_flash.connect(_on_player_hit_flash)
	

func _physics_process(delta: float) -> void:
	#print(GameDataManager.curssrent_hp)
	is_animation_hurt = animation_player.current_animation == "hurt"
	
	if isMoving:
		var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if direction != Vector2.ZERO:
			velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
			if not is_animation_hurt:
				animation_player.play_backwards("walk")
				
		else:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			if not is_animation_hurt:
				animation_player.play("iddle")
				
	else:
		velocity = velocity.move_toward(Vector2.ZERO, (FRICTION * 0.1) * delta)
		if not is_animation_hurt and animation_player.current_animation != "hurt":
			animation_player.play("iddle")
	
	gun_rotation()
	move_and_slide()
		
func gun_rotation():
	var mouse_position = get_global_mouse_position()
	gun_marker.look_at(mouse_position)
	if mouse_position.x < global_position.x:
		gun.scale.y = -1 
		player_body.scale.x = -1
		if not is_animation_hurt and velocity != Vector2.ZERO: 
			animation_player.play("walk")
	else:
		gun.scale.y = 1
		player_body.scale.x = 1
		
func _exit_tree() -> void:
	if PlayerManager.player == self:
		PlayerManager.player = null
		
#func take_damage(amount: int):
	#GameDataManager.current_hp -= amount
	#if GameDataManager.current_hp <= 0:
		#die()
#
#func shoot():
	#if GameDataManager.ammo > 0:
		#GameDataManager.ammo -= 1

func die():
	SignalBus.player_died.emit()
	
func _knockback(damage, attacker_position, attacker_size):
	on_hit_flash.emit(true) 
	#animation_player.play("hurt")
	#await animation_player.animation_finished
	#animation_player.play("RESET")
	GameDataManager.current_hp -= damage
	isMoving = false

	var knockback_direction = (global_position - attacker_position).normalized()

	var size_factor = clamp(attacker_size, 0.5, 3.0)

	var instant_push = 10.0 * size_factor
	global_position += knockback_direction * instant_push

	var base_knockback = GameDataManager.KNOCKBACK
	var strength = base_knockback * (1.0 + size_factor * 2.0)
	strength = clamp(strength, 200.0, 800.0)
	velocity = knockback_direction * strength
	velocity *= 1.1
	timer.wait_time = 0.1 + (0.1 * size_factor)
	timer.start()

func _on_player_hit_flash(knockback : bool) -> void:
	if knockback:
		animation_player.play("hurt")
	else:
		if animation_player.current_animation == "hurt":
			await animation_player.animation_finished
		animation_player.play("RESET")
		

	
func _on_timer_timeout() -> void:
	isMoving = true
	on_hit_flash.emit(false)
	pass # Replace with function body.


func _on_player_hurt_box_area_area_entered(area: Area2D) -> void:
	if area.name == "BulletArea":
		var bullet = area.get_parent()
		if bullet is Bullet and bullet.target_group == "PlayerHurtBox":
			print("kena peluru woi")
			var damage = 10.0
			var attacker_position = area.global_position
			var attacker_size = 1.0
			_knockback(damage, attacker_position, attacker_size)

	pass # Replace with function body.
