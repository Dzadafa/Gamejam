extends Node2D

@onready var menu_main = $CanvasMenuMain
@onready var menu_pause = $CanvasMenuPause
@onready var menu_tutorial = $CanvasTutorial
@onready var menu_credit = $CanvasCredits
@onready var ui_player = $CanvasUIPlayer
@onready var menu_restart_game = $CanvasRestartGame
@onready var player = $Player
@onready var RadarMinimap = $RadarMinimap

var is_game_started: bool = false 

func _ready() -> void:
	show_main_menu()
	RadarMinimap.hide()
	SignalBus.player_died.connect(_on_player_died)
func show_main_menu() -> void:
	is_game_started = false 
	
	menu_main.show()
	menu_pause.hide()
	menu_tutorial.hide()
	ui_player.hide()
	
	get_tree().paused = true 

func start_game() -> void:
	is_game_started = true 
	
	menu_main.hide()
	ui_player.show()
	RadarMinimap.show()
	get_tree().paused = false

func pause_game() -> void:
	menu_pause.show()
	get_tree().paused = true

func resume_game() -> void:
	menu_pause.hide()
	
	if is_game_started:
		get_tree().paused = false
	else:
		get_tree().paused = true

func _on_player_died() -> void:
	await get_tree().create_timer(1.5, true, false, true).timeout 
	ui_player.hide()
	RadarMinimap.hide()
	menu_restart_game.show()
	get_tree().paused = true

func tutorial_game() -> void:
	menu_tutorial.show()
	
func credit_game() -> void:
	menu_credit.show()
