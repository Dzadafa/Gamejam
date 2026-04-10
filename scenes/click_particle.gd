extends Node2D

@onready var click_particle_mouse = $ClickParticleMouse
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 4
	click_particle_mouse.one_shot = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
