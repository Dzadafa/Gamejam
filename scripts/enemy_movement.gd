extends CharacterBody2D
class_name Enemy

@onready var timer = $Timer
@onready var enemy_body = $Body
@onready var enemy_collision = $EnemyCollision
@onready var enemy_hurt_box_area = $EnemyHurtBoxArea
@onready var texture_progress_bar = $TextureProgressBar
@onready var enemy_hurt_box_collision = $EnemyHurtBoxArea/EnemyHurtBoxCollision
@onready var enemy_hit_box_collision = $EnemyHitBoxArea/EnemyHitBoxCollision


const ACCELERATION = SPEED * 5
const FRICTION = SPEED * 4
const SPEED : float = 300.0
const HP : float = 100.0
const PLAYER_DAMAGE = GameDataManager.DAMAGE
const KNOCKBACK : float = GameDataManager.KNOCKBACK

var isChasing = false
var isHurting = false
var isHittingPlayer = true

var attack_range : float = 50.0
var attack_damage : float = 15.0
var speed_multiplier : float
var hp_multiplier : float
var knockback_multiplier : float
var current_hp : float
var enemy_size: float

var bullet_area : Area2D = null
var player_hurt_box_area : Area2D = null

func _ready() -> void:
	speed_multiplier = randf_range(0.2, 1.0)
	hp_multiplier = randf_range(0.1, 2.0)
	current_hp = HP * hp_multiplier
	texture_progress_bar.min_value = 0          
	texture_progress_bar.max_value = current_hp
	texture_progress_bar.value = current_hp
	enemy_size = current_hp / 100
	enemy_body.scale.x = enemy_size
	enemy_body.scale.y = enemy_size
	enemy_hurt_box_collision.scale.x = enemy_size
	enemy_hurt_box_collision.scale.y = enemy_size
	enemy_hit_box_collision.scale.x = enemy_size
	enemy_hit_box_collision.scale.y = enemy_size
	knockback_multiplier = enemy_size
	collision_layer = 3
	collision_mask = 4
	timer.wait_time = 2
	
func _physics_process(delta: float) -> void:
	#print(GameDataManager.current_hp)
	
	if GameDataManager.isRestart:
		isHittingPlayer = false
		timer.stop()
		
	if isHurting:
		player_attacked(bullet_area.global_position)
		isHurting = false
		
	if isHittingPlayer:
		attack(player_hurt_box_area.global_position, enemy_size)
		isHittingPlayer = false
		
	if current_hp <= 0:
		enemy_die()
		return
		
	if PlayerManager.is_player_alive():
		var player_position = PlayerManager.player.global_position
		var distance_to_player = global_position.distance_to(player_position)
		var direction = global_position.direction_to(player_position)
		
		if distance_to_player > attack_range and velocity.length() < SPEED:
			chase_player(direction, delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			
		handle_flip(direction.x)
		move_and_slide()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		move_and_slide()

func chase_player(direction: Vector2, delta: float):
	var target_velocity = direction * SPEED * speed_multiplier
	velocity = velocity.move_toward(target_velocity, ACCELERATION * delta)

func handle_flip(move_direction_x: float):
	if move_direction_x > 0.1:
		enemy_body.scale.x = -1 * enemy_size
	elif move_direction_x < -0.1:
		enemy_body.scale.x = 1 * enemy_size

func player_attacked(attacker_position: Vector2):
	current_hp -= PLAYER_DAMAGE
	texture_progress_bar.value -= PLAYER_DAMAGE

	var enemy_knockback_direction = (global_position - attacker_position).normalized()
	velocity = enemy_knockback_direction * max(0,(KNOCKBACK - (KNOCKBACK * knockback_multiplier)))
	
func attack(enemy_attack_position: Vector2, enemy_attacker_size : float):
	SignalBus.enemy_hit.emit(attack_damage, enemy_attack_position, enemy_attacker_size)
	pass
	
func enemy_die():
	#print("enemy mati")
	deactivate()
	pass
	
func deactivate():
	hide()
	set_physics_process(false)
	
	enemy_collision.set_deferred("disabled", true)
	
	if enemy_hurt_box_area:
		enemy_hurt_box_area.set_deferred("monitoring", false)
		enemy_hurt_box_area.set_deferred("monitorable", false)

func activate(spawn_position: Vector2):
	global_position = spawn_position
	
	_ready()
	
	show()
	set_physics_process(true)
	
	enemy_collision.set_deferred("disabled", false)
	
	if enemy_hurt_box_area:
		enemy_hurt_box_area.set_deferred("monitoring", true)
		enemy_hurt_box_area.set_deferred("monitorable", true)
		
func _on_hurt_box_area_area_entered(area: Area2D) -> void:
	if area.name == "BulletArea":
		isHurting = true
		bullet_area = area
	
		
	pass # Replace with function body.

func _on_timer_timeout() -> void:
	isHittingPlayer = true
	pass # Replace with function body.


func _on_enemy_hit_box_area_area_entered(area: Area2D) -> void:
	if area.name == "PlayerHurtBoxArea":
		isHittingPlayer = true
		player_hurt_box_area = area
		timer.start()
	pass # Replace with function body.


func _on_enemy_hit_box_area_area_exited(area: Area2D) -> void:
	if area.name == "PlayerHurtBoxArea":
		
		timer.stop()
	pass # Replace with function body.
