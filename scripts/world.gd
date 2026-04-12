extends Node2D

@onready var menu_main = $CanvasMenuMain
@onready var menu_pause = $CanvasMenuPause
@onready var menu_tutorial = $CanvasTutorial
@onready var menu_credit = $CanvasCredits
@onready var ui_player = $CanvasUIPlayer
@onready var menu_restart_game = $CanvasRestartGame
@onready var player = $Player
@onready var RadarMinimap = $RadarMinimap
@onready var intro_canvas = $intro
@onready var menu_bgm = $MenuBGM
@onready var game_bgm = $GameBGM

var intro = preload("res://scenes/cutscenes/intro.tscn")

var is_game_started: bool = false 
var is_ending: bool = false 

func _ready() -> void:
	get_tree().paused = true
	menu_main.hide()
	menu_pause.hide()
	menu_tutorial.hide()
	ui_player.hide()
	RadarMinimap.hide()
	
	var intro_instance = intro.instantiate()
	intro_instance.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(intro_instance)
	
	var anim_player = intro_instance.get_node("AnimationPlayer")
	await anim_player.animation_finished
	intro_instance.queue_free()
	intro_canvas.hide()
	call_deferred("show_main_menu")
	
	SignalBus.player_died.connect(_on_player_died)
	SignalBus.game_ended.connect(_on_game_ended_ui_hide)
	SignalBus.back_to_main_menu.connect(_on_back_to_main_menu)
	
func show_main_menu() -> void:
	is_game_started = false 
	is_ending = false
	
	menu_main.show()
	menu_pause.hide()
	menu_tutorial.hide()
	ui_player.hide()
	
	get_tree().paused = true 
	game_bgm.stop()
	if not menu_bgm.playing:
		menu_bgm.play()

func start_game() -> void:
	is_game_started = true 
	is_ending = false
	
	menu_main.hide()
	ui_player.show()
	RadarMinimap.show()
	get_tree().paused = false
	menu_bgm.stop()
	if not game_bgm.playing:
		game_bgm.play()

func pause_game() -> void:
	if is_ending:
		return 
		
	menu_pause.show()
	get_tree().paused = true

func resume_game() -> void:
	menu_pause.hide()
	
	if is_game_started:
		get_tree().paused = false
	else:
		get_tree().paused = true

func _on_player_died() -> void:
	if is_ending:
		return 
		
	await get_tree().create_timer(1.5, true, false, true).timeout 
	
	if is_ending:
		return
		
	ui_player.hide()
	RadarMinimap.hide()
	menu_restart_game.show()
	get_tree().paused = true
	game_bgm.stop()

func tutorial_game() -> void:
	menu_tutorial.show()
	
func credit_game() -> void:
	menu_credit.show()

func _on_game_ended_ui_hide(ending_type: String) -> void:
	is_ending = true 
	
	ui_player.hide()
	RadarMinimap.hide()
	
	menu_pause.hide()

func _on_back_to_main_menu() -> void:
	GameDataManager.is_game_over = false
	GameDataManager.current_dna = 0.0
	GameDataManager.current_time = 0.0
	GameDataManager.current_hp = GameDataManager.MAX_HP
	GameDataManager.current_ammo = GameDataManager.MAG_SIZE
	
	get_tree().paused = false
	get_tree().reload_current_scene()
