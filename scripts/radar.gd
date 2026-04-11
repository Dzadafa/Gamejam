extends CanvasLayer

@export var player_sprite : CharacterBody2D

@onready var minimap_player_icon = $SubViewportContainer/SubViewport/MinimapPlayerIcon
@onready var icon_template = $SubViewportContainer/SubViewport/MinimapEnemyIcon
@onready var sub_viewport = $SubViewportContainer/SubViewport
@onready var minimap_camera = $SubViewportContainer/SubViewport/MinimapCamera
@onready var timer = $SubViewportContainer/SubViewport/Timer

var can_scan = true
var radar_blips = []

func _ready() -> void:
	timer.wait_time = 2.0
	timer.one_shot = true 
	icon_template.hide()

func _physics_process(delta: float) -> void:
	if player_sprite:
		minimap_player_icon.position = player_sprite.position
		minimap_camera.position = player_sprite.position
	
	if Input.is_action_just_pressed("klik_kanan_mouse") and can_scan:
		scan_radar()
		can_scan = false
		timer.start()

func scan_radar() -> void:
	for blip in radar_blips:
		if is_instance_valid(blip):
			blip.queue_free()
	radar_blips.clear()
	
	var active_enemies = EnemyPoolManager.get_active_enemies()
	
	for enemy in active_enemies:
		var new_blip = icon_template.duplicate()
		new_blip.position = enemy.global_position
		new_blip.show()
		
		sub_viewport.add_child(new_blip)
		radar_blips.append(new_blip)

func _on_timer_timeout() -> void:
	can_scan = true
	# for blip in radar_blips:
	#     if is_instance_valid(blip):
	#         blip.queue_free()
	# radar_blips.clear()
