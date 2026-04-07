extends CharacterBody2D
class_name Enemy


@onready var chasing_timer = $Timer
var target_body_player = null
var target_area_player = null
const ACCELERATION = SPEED * 5
const FRICTION = SPEED * 4

var isAttacking = false
var isChasing = false
const SPEED : float =  300.0
var speed_multiplier : float = 1.0
func _ready() -> void:
	chasing_timer.wait_time = 0.25
func _physics_process(delta: float) -> void:
	#print("isChasing" + str(isAttacking))
	#print("isAttacking" + str(isAttacking))
	if isChasing and target_body_player != null:
		var enemy_direction = (target_body_player.global_position - global_position).normalized()
		velocity = velocity.move_toward(enemy_direction * SPEED * speed_multiplier, ACCELERATION * delta) 
		look_at(target_body_player.global_position)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move_and_slide()
	pass 

#cek memakai collision layer (player = 1, enemy = 2) 
func _on_chase_area_area_entered(area: Area2D) -> void:
	isChasing = true
	pass 

func _on_chase_area_area_exited(area: Area2D) -> void:
	target_body_player = null
	isChasing = false
	isAttacking = false
	pass # Replace with function body.

func _on_chase_area_body_entered(body: Node2D) -> void:
	target_body_player = body
	isChasing = true
	pass
	
func _on_hit_box_area_body_entered(body: Node2D) -> void:
	isAttacking = true
	speed_multiplier = 0.2
	chasing_timer.start()
	pass
	
func _on_hit_box_area_body_exited(body: Node2D) -> void:
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	isAttacking = true
	pass # Replace with function body.
