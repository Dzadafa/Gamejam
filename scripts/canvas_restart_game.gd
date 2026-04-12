extends CanvasLayer

@onready var world = $".."

func _ready() -> void:
	self.hide()

func _on_texture_button_play_pressed() -> void:
	get_tree().paused = false 
	
	GameDataManager.current_hp = GameDataManager.MAX_HP
	GameDataManager.current_ammo = GameDataManager.MAG_SIZE
	GameDataManager.current_dna = 0.0
	GameDataManager.current_time = 0.0 
	world.show_main_menu()
	
func _on_texture_button_exit_pressed() -> void:
	self.hide()
	world.show_main_menu()
