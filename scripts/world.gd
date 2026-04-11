extends Node2D

@onready var menu_main = $CanvasMenuMain
@onready var menu_pause = $CanvasMenuPause
@onready var menu_tutorial = $CanvasTutorial
@onready var ui_player = $CanvasUIPlayer
@onready var player = $Player
@onready var RadarMinimap = $RadarMinimap

var is_game_started: bool = false 

func _ready() -> void:
	show_main_menu()
	RadarMinimap.hide()

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
