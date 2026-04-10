extends Node2D

class_name Bullet

@onready var bullet_collision = $BulletArea/BulletCollision
@onready var bullet_area = $BulletArea
@onready var bullet_explosion = $BulletExplosion
@onready var bullet_sprite = $BulletSprite


const SPEED = 1500
var bullet_direction = Vector2.ZERO 
var target_group : String = "PlayerHurtBox"

func _ready() -> void:
	z_index = 4
	if bullet_explosion != null:
		bullet_explosion.emitting = false 
	pass

func _physics_process(delta: float) -> void:
	global_position += bullet_direction * SPEED * delta
	on_scanning_gun()
	

func _on_visible_on_screen_notifier_2d_screen_exited():
	deactivate()

func deactivate():
	hide()
	set_physics_process(false)
	
	if bullet_collision != null:
		bullet_collision.set_deferred("disabled", true)
		
	if bullet_area != null:
		bullet_area.set_deferred("monitoring", false)
		
func activate(start_position: Vector2, direction: Vector2, position_target_group: String = "EnemyHurtBox"):
	global_position = start_position
	bullet_direction = direction
	target_group = position_target_group
	
	if bullet_explosion != null:
		bullet_explosion.emitting = false
		
	show()
	set_physics_process(true)
	
	if bullet_sprite != null:
		if BulletPoolManager.isScanning:
			bullet_sprite.hide() 
		else:
			bullet_sprite.show()
		
	if bullet_area != null:
		bullet_area.set_deferred("monitoring", true)
		bullet_area.set_deferred("monitorable", true)
		
	if bullet_collision != null:
		bullet_collision.set_deferred("disabled", false) 


func _on_bullet_area_area_entered(area: Area2D) -> void:	
	#print("menabrak Area: ", area.name, "grup Enemy? ", area.is_in_group("Enemy"))
	if area.is_in_group(target_group):
		print("peluru mengenai target")
			
		set_physics_process(false)
		
		if bullet_collision != null:
			bullet_collision.set_deferred("disabled", true)
		if bullet_area != null:
			bullet_area.set_deferred("monitoring", false)
			
		if bullet_sprite != null:
			bullet_sprite.hide()
			
		bullet_explosion.one_shot = true
		bullet_explosion.restart() 
		bullet_explosion.emitting = true
	
		await get_tree().create_timer(bullet_explosion.lifetime).timeout
		deactivate()
		pass # Replace with function body.

func on_scanning_gun():
	if BulletPoolManager.isScanning:
		if bullet_sprite != null:
			bullet_sprite.visible = false
	else:
		if bullet_sprite != null:
			bullet_sprite.visible = true
