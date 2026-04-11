extends CanvasLayer

@onready var world = $".."
@onready var label = $Label
@onready var label2 = $Label2
@onready var texture_tutorial = $TextureRect
@onready var button =  $TextureButton
@onready var button_next = $TextureRect/TextureButtoNextn
@onready var button_previews = $TextureRect/TextureButtonpreview


var tutorial_1 = preload("res://assets/How_to_play_1.png")
var tutorial_2 = preload("res://assets/How_to_play_2.png")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_tutorial.texture = tutorial_1
	self.hide()
	label2.hide()
	button_previews.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	self.hide()
	pass # Replace with function body.


func _on_texture_butto_nextn_pressed() -> void:
	texture_tutorial.texture = tutorial_2
	button_next.hide()
	button_previews.show()
	label.hide()
	label2.show()
	pass # Replace with function body.


func _on_texture_butto_nextn_2_pressed() -> void:
	texture_tutorial.texture = tutorial_1
	button_previews.hide()
	button_next.show()
	label2.hide()
	label.show()
	pass # Replace with function body.
