extends Node

enum GameState { MAIN_MENU, GAMEPLAY, SETTINGS, CREDITS, TUTORIAL }
var current_state : GameState = GameState.MAIN_MENU

const SCENES = {
	GameState.MAIN_MENU: "res://scenes/menu/canvas_menu_main.tscn",
	GameState.GAMEPLAY: "res://scenes/world.tscn",
	GameState.SETTINGS: "res://scenes/menu/canvas_menu_pause.tscn",
	GameState.CREDITS: "res://scenes/menu/canvas_menu_pause.tscn",
	GameState.TUTORIAL: "res://scenes/menu/canvas_menu_pause.tscn"
}

func switch_scene(new_state: GameState):
	current_state = new_state
	var scene_path = SCENES.get(new_state)
	
	if scene_path:
		get_tree().change_scene_to_file(scene_path)
	else:
		push_error("Path untuk state ", new_state, " tidak ditemukan!")

func set_paused(is_paused: bool):
	get_tree().paused = is_paused
