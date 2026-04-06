extends CharacterBody2D


const SPEED = 400.0
const ACCELERATION = SPEED * 5
const FRICTION = SPEED * 4

@export var bullet_scene : PackedScene
@onready var gun_marker = $GunPivot
@onready var gun = $Gun



func _physics_process(delta: float) -> void:

	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move_and_slide()
	gun_rotation()
		
func gun_rotation():
	var mouse_position = get_global_mouse_position()
	gun.look_at(mouse_position)
	if mouse_position.x < global_position.x:
		gun.scale.y = -1 # Balik sumbu Y agar tidak upside down
	else:
		gun.scale.y = 1
