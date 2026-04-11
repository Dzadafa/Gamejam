extends CharacterBody2D
class_name Enemy

@export_category("Enemy Nodes")
enum Behavior { AGGRESSIVE, PASSIVE }
@export var behavior : Behavior = Behavior.AGGRESSIVE
@export var timer : Timer
@export var enemy_body : Node2D
@export var enemy_collision : CollisionShape2D 
@export var enemy_hurt_box_area : Area2D
@export var enemy_hit_box_area : Area2D
@export var animation_enemy : AnimationPlayer 
@export var texture_progress_bar : TextureProgressBar
@export var label : Label
@export var enemy_hurt_box_collision : CollisionShape2D
@export var enemy_hit_box_collision : CollisionShape2D
@export var enemy_chase_area_collision : CollisionShape2D
@export var enemy_die_particle : CPUParticles2D
@export var shoot_timer : Timer
@export var shoot_position : Marker2D 
@export var audio_stream_enemy : AudioStreamPlayer2D 

@export_category("Run & Attack Skill")
@export var has_run_attack: bool = false 
@export var run_attack_duration: float = 0.8 
@export var run_attack_cooldown_max: float = 4.0 
@export var run_attack_speed_mult: float = 3.0 
@export var run_attack_prep_time: float = 0.5
var is_preparing_run_attack: bool = false
var dash_direction: Vector2 = Vector2.ZERO
var can_shoot := true

const SPEED : float = 300.0
const HP : float = 200.0
const DISTANCE_AREA : float = 50.0

var player_knockback : float = GameDataManager.KNOCKBACK
var player_damage = GameDataManager.DAMAGE

var isChasing = false
var isHurting = false
var isHittingPlayer = false
var isDead = false

var is_run_attacking = false
var run_attack_timer: float = 0.0
var run_attack_cooldown: float = 0.0

var shoot_range : float =  500
var speed_multiplier : float
var hp_multiplier : float
var knockback_multiplier : float
var current_hp : float
var enemy_size: float

@export var base_speed : float = 300.0
@export var base_hp : float = 200.0
@export var attack_range : float = 50.0
@export var attack_damage : float = 15.0
@export var base_shoot_range : float = 500.0

var acceleration : float
var friction : float

var bullet_area : Area2D = null
var player_hurt_box_area : Area2D = null

func _ready() -> void:
	label.text = name
	z_index = 3
	acceleration = base_speed * 5
	friction = base_speed * 4
	
	setup_enemy() 
	
	timer.wait_time = 2.0
	
	if shoot_timer != null:
		shoot_timer.wait_time = 1.2 
		if not shoot_timer.timeout.is_connected(_on_shoot_timer_timeout):
			shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	
func _physics_process(delta: float) -> void:
	if isDead:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		move_and_slide()
		return
		
	if run_attack_cooldown > 0:
		run_attack_cooldown -= delta
		
	if is_run_attacking:
		run_attack_timer -= delta
		if run_attack_timer <= 0:
			is_run_attacking = false
			
	if GameDataManager.isRestart:
		isHittingPlayer = false
		timer.stop()
		
	if isHurting:
		if is_instance_valid(bullet_area):
			player_attacked(bullet_area.global_position)
		isHurting = false
		
	if isHittingPlayer:
		if is_instance_valid(player_hurt_box_area):
			attack(global_position, enemy_size)
		isHittingPlayer = false
		
	if current_hp <= 0 and not isDead:
		isDead = true 
		enemy_die()
		return
		
	if PlayerManager.is_player_alive() and isChasing and behavior == Behavior.AGGRESSIVE:
		var player_position = PlayerManager.player.global_position
		var distance_to_player = global_position.distance_to(player_position)
		var direction = global_position.direction_to(player_position)
		
		if distance_to_player <= shoot_range and can_shoot and shoot_timer != null and not is_run_attacking:
			shoot_at_player()
			can_shoot = false
			shoot_timer.start()
		
		var is_busy = false
		if animation_enemy != null:
			var busy_anims = ["hit_flash", "throw_foot", "attack", "run_and_attack"]
			is_busy = animation_enemy.is_playing() and (animation_enemy.current_animation in busy_anims)
			
		if has_run_attack and not is_run_attacking and not is_preparing_run_attack and run_attack_cooldown <= 0 and distance_to_player > attack_range and distance_to_player < (attack_range * 4):
			is_preparing_run_attack = true
			run_attack_timer = run_attack_prep_time
			dash_direction = direction 
			
			if animation_enemy != null and animation_enemy.has_animation("idle"):
				animation_enemy.play("idle") 

		if is_preparing_run_attack:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			run_attack_timer -= delta
			
			if run_attack_timer <= 0:
				is_preparing_run_attack = false
				is_run_attacking = true
				run_attack_timer = run_attack_duration
				run_attack_cooldown = run_attack_cooldown_max
				
				if animation_enemy != null and animation_enemy.has_animation("run_and_attack"):
					animation_enemy.play("run_and_attack")
					
		elif is_run_attacking:
			var dash_velocity = dash_direction * base_speed * speed_multiplier * run_attack_speed_mult
			velocity = velocity.move_toward(dash_velocity, (acceleration * 3) * delta) 
		elif distance_to_player > attack_range:
			chase_player(direction, delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			if not is_busy and animation_enemy != null and animation_enemy.has_animation("idle"):
				animation_enemy.play("idle")
				
		handle_flip(direction.x)
		move_and_slide()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		move_and_slide()
		
		if animation_enemy != null:
			var is_busy = false
			var ignore_anims = ["hit_flash", "attack", "run_and_attack", "throw_foot"]
			is_busy = animation_enemy.is_playing() and (animation_enemy.current_animation in ignore_anims)
			
			if not is_busy and animation_enemy.has_animation("idle"):
				animation_enemy.play("idle")
		
func chase_player(direction: Vector2, delta: float):
	var target_velocity = direction * base_speed * speed_multiplier
	velocity = velocity.move_toward(target_velocity, acceleration * delta)
	
	var is_busy = false
	if animation_enemy != null:
		var busy_anims = ["hit_flash", "throw_foot", "attack", "run_and_attack"]
		is_busy = animation_enemy.is_playing() and (animation_enemy.current_animation in busy_anims)
		
	if not is_busy and animation_enemy != null and animation_enemy.has_animation("walk"):
		animation_enemy.play("walk")

func handle_flip(move_direction_x: float):
	if move_direction_x > 0.1:
		enemy_body.scale.x = -1 * enemy_size
	elif move_direction_x < -0.1:
		enemy_body.scale.x = 1 * enemy_size
		
func reset_shader_state():
	if enemy_body and enemy_body.material:
		if not enemy_body.material.resource_local_to_scene:
			enemy_body.material = enemy_body.material.duplicate()
		
		enemy_body.material.set_shader_parameter("hit_flash_on", false)
	
	if animation_enemy != null and animation_enemy.is_playing():
		if animation_enemy.current_animation == "hit_flash":
			animation_enemy.stop()

func setup_enemy():
	speed_multiplier = randf_range(0.2, 1.0) 
	hp_multiplier = randf_range(0.1, 0.3)
	current_hp = base_hp * hp_multiplier
	texture_progress_bar.max_value = current_hp
	texture_progress_bar.value = current_hp
	enemy_size = current_hp / 100
	enemy_body.scale = Vector2(enemy_size, enemy_size)
	
	if enemy_collision != null:
		enemy_collision.scale = Vector2(enemy_size, enemy_size)
	
	if enemy_hurt_box_collision != null:
		enemy_hurt_box_collision.scale = Vector2(enemy_size, enemy_size)
	if enemy_hit_box_collision != null:
		enemy_hit_box_collision.scale = Vector2(enemy_size, enemy_size)
	
	if enemy_chase_area_collision != null:
		var chase_scale = enemy_size + (DISTANCE_AREA / 100.0) 
		enemy_chase_area_collision.scale = Vector2(chase_scale, chase_scale)
	
	knockback_multiplier = enemy_size
	shoot_range = base_shoot_range * enemy_size + base_shoot_range
	
func player_attacked(attacker_position: Vector2):
	is_run_attacking = false 
	
	if animation_enemy != null:
		animation_enemy.stop() 
		reset_shader_state()
		animation_enemy.play("hit_flash")
		
	current_hp -= player_damage
	
	if texture_progress_bar != null:
		texture_progress_bar.value -= player_damage
		
	var enemy_knockback_direction = (global_position - attacker_position).normalized()
	velocity = enemy_knockback_direction * max(0,(player_knockback - (player_knockback * knockback_multiplier)))
	
func attack(enemy_attack_position: Vector2, enemy_attacker_size : float):
	if animation_enemy != null and animation_enemy.has_animation("attack"):
		animation_enemy.play("attack")
		
		await get_tree().create_timer(0.3).timeout 
		
	if isDead:
		return
		
	var attack_valid= false
	if is_instance_valid(player_hurt_box_area) and enemy_hit_box_area != null:
		if enemy_hit_box_area.overlaps_area(player_hurt_box_area):
			attack_valid = true
			
	if attack_valid:
		SignalBus.enemy_hit.emit(attack_damage, global_position, enemy_attacker_size)

func shoot_at_player():
	if not PlayerManager.is_player_alive():
		return
		
	if animation_enemy != null and animation_enemy.has_animation("throw_foot"):
		animation_enemy.play("throw_foot")

func spawn_bullet():
	if not PlayerManager.is_player_alive():
		return
		
	if shoot_position == null:
		return
		
	var bullet = BulletPoolManager.get_bullet()
	if bullet == null:
		return
		
	var player_position = PlayerManager.player.global_position
	var direction = (player_position - shoot_position.global_position).normalized()
	
	direction += Vector2(randf_range(-0.1, 0.1), randf_range(-0.1, 0.1))
	direction = direction.normalized()
	bullet.activate(shoot_position.global_position, direction, "PlayerHurtBox", enemy_size)
	bullet.look_at(player_position)
	
func enemy_die():
	if isChasing:
		GameDataManager.chasing_count = max(0, GameDataManager.chasing_count - 1)
	
	if animation_enemy != null and animation_enemy.has_animation("die"):
		animation_enemy.play("die")
		await animation_enemy.animation_finished
	
	if enemy_hit_box_area != null:
		enemy_hit_box_area.set_deferred("monitoring", false)
		enemy_hit_box_area.set_deferred("monitorable", false)
	
	if enemy_die_particle != null:
		enemy_die_particle.one_shot = true
		enemy_die_particle.emitting = true
		
		await get_tree().create_timer(enemy_die_particle.lifetime).timeout
	else:
		await get_tree().create_timer(1.0).timeout
		
	deactivate()
	
func deactivate():
	hide()
	set_physics_process(false)
	
	enemy_collision.set_deferred("disabled", true)
	
	if enemy_hurt_box_area:
		enemy_hurt_box_area.set_deferred("monitoring", false)
		enemy_hurt_box_area.set_deferred("monitorable", false)
		
	if enemy_hit_box_area:
		enemy_hit_box_area.set_deferred("monitoring", false)
		enemy_hit_box_area.set_deferred("monitorable", false)

func activate(spawn_position: Vector2):
	isDead = false
	is_run_attacking = false 
	global_position = spawn_position
	
	reset_shader_state()
	setup_enemy()
	
	show()
	set_physics_process(true)
	
	enemy_collision.set_deferred("disabled", false)
	
	if enemy_hurt_box_area:
		enemy_hurt_box_area.set_deferred("monitoring", true)
		enemy_hurt_box_area.set_deferred("monitorable", true)
		
	if enemy_hit_box_area:
		enemy_hit_box_area.set_deferred("monitoring", true)
		enemy_hit_box_area.set_deferred("monitorable", true)

func _on_timer_timeout() -> void:
	isHittingPlayer = true

func _on_enemy_hurt_box_area_area_entered(area: Area2D) -> void:
	if area.name == "BulletArea":
		var bullet = area.get_parent()
		if bullet is Bullet and bullet.target_group == "EnemyHurtBox":
			if not BulletPoolManager.isScanning:
				player_attacked(area.global_position) 
			else:
				GameDataManager.current_dna += 5.0

func _on_enemy_hit_box_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerHurtBox"):
		isHittingPlayer = true
		player_hurt_box_area = area
		timer.start()

func _on_enemy_hit_box_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("PlayerHurtBox"):
		timer.stop()

func _on_enemy_chase_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		isChasing = true
		GameDataManager.chasing_count += 1

func _on_enemy_chase_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		isChasing = false
		GameDataManager.chasing_count -= 1
		GameDataManager.chasing_count = max(0, GameDataManager.chasing_count)

func _on_shoot_timer_timeout() -> void:
	can_shoot = true
