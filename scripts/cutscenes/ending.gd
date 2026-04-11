extends Node2D
class_name ending

var animation_player 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.game_ended.connect(_on_game_ended)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func normal_ending():
	animation_player = $AnimationPlayer
	animation_player.play("dna_scan")
	await animation_player.animation_finished
	animation_player.play("reveal")
	await animation_player.animation_finished
	animation_player.play("lose")
	await animation_player.animation_finished
	
func loser_ending():
	animation_player = $AnimationPlayer
	animation_player.play("loser")
	await animation_player.animation_finished
	
func easter_egg():
	animation_player = $AnimationPlayer
	animation_player.play("dna_scan")
	await animation_player.animation_finished
	animation_player.play("reveal")
	await animation_player.animation_finished
	animation_player.play("easter_egg")
	await animation_player.animation_finished

func _on_game_ended(ending_type: String) -> void:
	get_tree().paused = true
	self.show() 
	
	if ending_type == "easter_egg":
		easter_egg()
	elif ending_type == "normal_ending":
		normal_ending()
	elif ending_type == "loser_ending":
		loser_ending()
