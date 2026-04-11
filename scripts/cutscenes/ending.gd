extends Node2D
class_name ending

var animation_player 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func normal_ending():
	animation_player = $AnimationPlayer
	$AnimationPlayer.play("dna_scan")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("reveal")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("lose")
	await $AnimationPlayer.animation_finished
	
func loser_ending():
	$AnimationPlayer.play("loser")
	await $AnimationPlayer.animation_finished
	
func easter_egg():
	animation_player = $AnimationPlayer
	$AnimationPlayer.play("dna_scan")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("reveal")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("easter_egg")
	await $AnimationPlayer.animation_finished
