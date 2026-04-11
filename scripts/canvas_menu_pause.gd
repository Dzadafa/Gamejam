extends CanvasLayer

const TEXTURE_ON = preload("res://assets/UI/Switch_On.png")
const TEXTURE_OFF = preload("res://assets/UI/Switch_Off.png")

@onready var music_button: TextureButton = $TextureButtonMusic
@onready var sfx_button: TextureButton = $TextureButtonSFX
@onready var world = $".." 



var is_music_on: bool = true
var is_sfx_on: bool = true

func _ready() -> void:
	music_button.pressed.connect(_on_music_button_pressed)
	sfx_button.pressed.connect(_on_sfx_button_pressed)
	self.hide()

func _on_music_button_pressed() -> void:
	is_music_on = !is_music_on 
	
	if is_music_on:
		music_button.texture_normal = TEXTURE_ON
	else:
		music_button.texture_normal = TEXTURE_OFF
	
	print("Music status: ", is_music_on)

func _on_sfx_button_pressed() -> void:
	is_sfx_on = !is_sfx_on
	
	if is_sfx_on:
		sfx_button.texture_normal = TEXTURE_ON
	else:
		sfx_button.texture_normal = TEXTURE_OFF
		
	print("SFX status: ", is_sfx_on)


func _on_texture_button_exit_pressed() -> void:
	self.hide()
	world.resume_game()
	pass # Replace with function body.


func _on_button_exit_menu_pause_pressed() -> void:
	self.hide()
	world.resume_game()
	pass # Replace with function body.
