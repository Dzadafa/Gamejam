extends CanvasLayer

@onready var TPB_health_bar_player = $TPBHealthBarPlayer
@onready var TPB_DNA_enemy = $TPBDNAEnemy
@onready var label_timer_end_game = $LabelTimerEndGame
@onready var texture_button_menu_pause = $TextureButtonMenuPause

var time_elapsed = GameDataManager.MAX_TIME

func _ready() -> void:
	TPB_health_bar_player.max_value = GameDataManager.MAX_HP
	TPB_DNA_enemy.max_value = GameDataManager.MAX_DNA
	
	TPB_health_bar_player.value = GameDataManager.current_hp
	TPB_DNA_enemy.value = GameDataManager.current_dna
	
	SignalBus.hp_changed.connect(_on_player_hp_changed)
	SignalBus.dna_changed.connect(_on_enemy_dna_changed)

func _on_player_hp_changed(new_hp: float) -> void:
	TPB_health_bar_player.value = new_hp

func _on_enemy_dna_changed(new_dna: float) -> void:
	TPB_DNA_enemy.value = new_dna

func _physics_process(delta: float) -> void:
	time_elapsed -= delta
	
	if time_elapsed < 0:
		time_elapsed = 0
		
	var minutes = int(time_elapsed) / 60
	var seconds = int(time_elapsed) % 60
	
	label_timer_end_game.text = "%02d:%02d" % [minutes, seconds]
	GameDataManager.current_time += delta
