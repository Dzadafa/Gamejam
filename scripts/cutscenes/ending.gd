extends Node2D

var animation_player 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await normal_ending()
	await loser_ending()
	await easter_ending()

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
	animation_player = $AnimationPlayer
	$AnimationPlayer.play("loser")
	await $AnimationPlayer.animation_finished
	
func easter_ending():
	animation_player = $AnimationPlayer
	$AnimationPlayer.play("easter_egg")
	await $AnimationPlayer.animation_finished
