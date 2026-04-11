extends Node

enum GameState {GAMEPLAY}
var current_state : GameState = GameState.GAMEPLAY

const SCENES = {
	GameState.GAMEPLAY: "res://scenes/world.tscn"}

func switch_scene(new_state: GameState):
	current_state = new_state
	var scene_path = SCENES.get(new_state)
	
	if scene_path:
		get_tree().change_scene_to_file(scene_path)
	else:
		push_error("Path untuk state ", new_state, " tidak ditemukan!")

func set_paused(is_paused: bool):
	get_tree().paused = is_paused
