extends Node2D

class_name Bullet

@onready var bullet_collision = $BulletArea/BulletCollision
@onready var bullet_area = $BulletArea

const SPEED = 500
var bullet_direction = Vector2.ZERO 
func _ready() -> void:
	set_physics_process(true)
	
	pass

func _physics_process(delta: float) -> void:
	global_position += bullet_direction * SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	deactivate()

func deactivate():
	hide()
	set_physics_process(false)
	
	if bullet_collision != null:
		bullet_collision.set_deferred("disabled", true)
		
	if bullet_area != null:
		bullet_area.set_deferred("monitoring", false)
		
func activate(start_position: Vector2, direction: Vector2):
	print("peluru aktif")
	global_position = start_position
	bullet_direction = direction
	print(bullet_area.collision_layer)
	print(bullet_area.collision_mask)
	
	show()
	set_physics_process(true)
	
	if bullet_area != null:
		bullet_area.set_deferred("monitoring", true)
		bullet_area.set_deferred("monitorable", true)
		
	if bullet_collision != null:
		bullet_collision.set_deferred("disabled", false) 


func _on_bullet_area_area_entered(area: Area2D) -> void:	
	#print("menabrak Area: ", area.name, "grup Enemy? ", area.is_in_group("Enemy"))
	if area.is_in_group("Enemy"):
		#print("peluru mengenai target")
		deactivate()
	pass # Replace with function body.
