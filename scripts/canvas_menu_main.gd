extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_play_pressed() -> void:
	SceneManager.switch_scene(SceneManager.GameState.GAMEPLAY)
	pass # Replace with function body.


func _on_texture_button_settings_pressed() -> void:
	SceneManager.switch_scene(SceneManager.GameState.SETTINGS)
	pass # Replace with function body.


func _on_texture_button_credits_pressed() -> void:
	SceneManager.switch_scene(SceneManager.GameState.CREDITS)
	pass # Replace with function body.


func _on_texture_button_tutorial_pressed() -> void:
	SceneManager.switch_scene(SceneManager.GameState.TUTORIAL)
	pass # Replace with function body.
