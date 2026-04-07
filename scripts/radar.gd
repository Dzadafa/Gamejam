extends CanvasLayer


@export var player_sprite : CharacterBody2D
@export var enemy_sprite : CharacterBody2D

@onready var minimap_player_icon = $SubViewportContainer/SubViewport/MinimapPlayerIcon
@onready var minimap_enemy_icon = $SubViewportContainer/SubViewport/MinimapEnemyIcon
@onready var sub_viewport = $SubViewportContainer/SubViewport
@onready var minimap_camera = $SubViewportContainer/SubViewport/MinimapCamera
@onready var timer = $SubViewportContainer/SubViewport/Timer
var isScanning = false
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	timer.wait_time = 2
	minimap_enemy_icon.position = enemy_sprite.position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if player_sprite:
		minimap_player_icon.position = player_sprite.position
		minimap_camera.position = player_sprite.position
	
	if Input.is_action_just_pressed("klik_kanan_mouse") and not isScanning:
		minimap_enemy_icon.position = enemy_sprite.position
		timer.start()
		isScanning = false
	pass


func _on_timer_timeout() -> void:
	isScanning = true
	pass # Replace with function body.
