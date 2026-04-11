extends CanvasLayer

func _ready() -> void:
	self.hide()

func _on_texture_button_play_pressed() -> void:
	get_tree().paused = false 
	
	GameDataManager.current_hp = GameDataManager.MAX_HP
	GameDataManager.current_ammo = GameDataManager.MAG_SIZE
	GameDataManager.current_dna = 0.0
	GameDataManager.current_time = 0.0 
	get_tree().reload_current_scene()
	
func _on_texture_button_exit_pressed() -> void:
	get_tree().quit()
