extends CanvasLayer

const TEXTURE_ON = preload("res://assets/UI/Switch_On.png")
const TEXTURE_OFF = preload("res://assets/UI/Switch_Off.png")

@onready var music_button: TextureButton = $TextureButtonMusic
@onready var sfx_button: TextureButton = $TextureButtonSFX
@onready var world = $".." 

var is_music_on: bool = true
var is_sfx_on: bool = true

var music_bus_idx: int
var sfx_bus_idx: int

func _ready() -> void:
	music_bus_idx = AudioServer.get_bus_index("Music")
	sfx_bus_idx = AudioServer.get_bus_index("SFX")
	is_music_on = !AudioServer.is_bus_mute(music_bus_idx)
	is_sfx_on = !AudioServer.is_bus_mute(sfx_bus_idx)
	music_button.texture_normal = TEXTURE_ON if is_music_on else TEXTURE_OFF
	sfx_button.texture_normal = TEXTURE_ON if is_sfx_on else TEXTURE_OFF
	
	self.hide()

func _on_texture_button_exit_pressed() -> void:
	self.hide()
	if world.menu_bgm: world.menu_bgm.stop()
	if world.game_bgm: world.game_bgm.stop()
	SignalBus.back_to_main_menu.emit()
	

func _on_button_exit_menu_pause_pressed() -> void:
	self.hide()
	world.resume_game()
	


func _on_texture_button_music_pressed() -> void:
	is_music_on = !is_music_on 
	
	if is_music_on:
		music_button.texture_normal = TEXTURE_ON
		world.menu_bgm.play()
	else:
		music_button.texture_normal = TEXTURE_OFF
		world.menu_bgm.play()
	
	AudioServer.set_bus_mute(music_bus_idx, !is_music_on)
	print("Music status: ", is_music_on)
	pass # Replace with function body.


func _on_texture_button_sfx_pressed() -> void:
	is_sfx_on = !is_sfx_on
	
	if is_sfx_on:
		sfx_button.texture_normal = TEXTURE_ON
	else:
		sfx_button.texture_normal = TEXTURE_OFF
		
	AudioServer.set_bus_mute(sfx_bus_idx, !is_sfx_on)
	print("SFX status: ", is_sfx_on)
	pass # Replace with function body.
