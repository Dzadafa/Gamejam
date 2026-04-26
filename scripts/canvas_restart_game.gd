extends CanvasLayer

@onready var world = $".."

func _ready() -> void:
	self.hide()

func _on_texture_button_play_pressed() -> void:
	GameDataManager.is_restarting_directly = true 
	world.mute_music()
	get_tree().paused = false 
	get_tree().reload_current_scene()
	
func _on_texture_button_exit_pressed() -> void:
	self.hide()
	world.on_music()
	if world.menu_bgm: world.menu_bgm.stop()
	if world.game_bgm: world.game_bgm.stop()
	SignalBus.back_to_main_menu.emit()
