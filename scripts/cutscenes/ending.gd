extends CanvasLayer
class_name ending

@onready var animation_player  = $AnimationPlayer
var music_bus_idx: int
var sfx_bus_idx: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide() 
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	animation_player.process_mode = Node.PROCESS_MODE_ALWAYS
	SignalBus.game_ended.connect(_on_game_ended)
	music_bus_idx = AudioServer.get_bus_index("Music")
	sfx_bus_idx = AudioServer.get_bus_index("SFX")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func normal_ending():
	AudioServer.set_bus_mute(sfx_bus_idx,true)
	AudioServer.set_bus_mute(music_bus_idx,true)
	animation_player = $AnimationPlayer
	animation_player.play("dna_scan")
	await animation_player.animation_finished
	animation_player.play("reveal")
	await animation_player.animation_finished
	animation_player.play("lose")
	await animation_player.animation_finished
	
func loser_ending():
	AudioServer.set_bus_mute(sfx_bus_idx,true)
	AudioServer.set_bus_mute(music_bus_idx,true)
	animation_player = $AnimationPlayer
	animation_player.play("loser")
	await animation_player.animation_finished
	
func easter_egg():
	AudioServer.set_bus_mute(sfx_bus_idx,true)
	AudioServer.set_bus_mute(music_bus_idx,true)
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
		await easter_egg()
	elif ending_type == "normal_ending":
		await normal_ending()
	elif ending_type == "loser_ending":
		await loser_ending()
	
	self.hide()
	SignalBus.back_to_main_menu.emit()
