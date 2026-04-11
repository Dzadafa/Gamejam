extends CanvasLayer

@onready var world = $".." 

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_texture_button_play_pressed() -> void:
	world.start_game()

func _on_texture_button_settings_pressed() -> void:
	# Cukup panggil ini, karena di dalam pause_game() 
	# menu pause sudah otomatis di-show dan game di-pause
	world.pause_game()

func _on_texture_button_credits_pressed() -> void:
	world.credit_game()
	pass 

func _on_texture_button_tutorial_pressed() -> void:
	world.tutorial_game()
	pass
