extends Area2D

const SPEED = 500
var bullet_direction = Vector2.ZERO 

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	global_position += bullet_direction * SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	deactivate()

func deactivate():
	hide()
	set_physics_process(false)
	
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)
