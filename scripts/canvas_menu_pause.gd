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
	music_button.pressed.connect(_on_music_button_pressed)
	sfx_button.pressed.connect(_on_sfx_button_pressed)
	music_bus_idx = AudioServer.get_bus_index("Music")
	sfx_bus_idx = AudioServer.get_bus_index("SFX")
	music_button.texture_normal = TEXTURE_ON
	sfx_button.texture_normal = TEXTURE_ON
	self.hide()

func _on_music_button_pressed() -> void:
	is_music_on = !is_music_on 
	
	if is_music_on:
		music_button.texture_normal = TEXTURE_ON
	else:
		music_button.texture_normal = TEXTURE_OFF
	
	AudioServer.set_bus_mute(music_bus_idx, !is_music_on)
	print("Music status: ", is_music_on)

func _on_sfx_button_pressed() -> void:
	is_sfx_on = !is_sfx_on
	
	if is_sfx_on:
		sfx_button.texture_normal = TEXTURE_ON
	else:
		sfx_button.texture_normal = TEXTURE_OFF
		
	AudioServer.set_bus_mute(sfx_bus_idx, !is_sfx_on)
	print("SFX status: ", is_sfx_on)

func _on_texture_button_exit_pressed() -> void:
	self.hide()
	world.show_main_menu()
	

func _on_button_exit_menu_pause_pressed() -> void:
	self.hide()
	world.resume_game()
	
