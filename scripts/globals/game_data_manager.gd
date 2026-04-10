extends Node

const MAX_HP: float = 100.0
const DAMAGE : float = 10.0
const KNOCKBACK : float = 500.0

const MAG_SIZE: int = 30 

var isRestart :bool = false
var current_hp: float = 100.0:
	set(value):
		current_hp = clamp(value, 0, MAX_HP)
		SignalBus.hp_changed.emit(current_hp)
		
		if current_hp <= 0:
			restart_game()

var current_ammo: int = MAG_SIZE:
	set(value):
		current_ammo = max(0, value)
		SignalBus.ammo_changed.emit(current_ammo)

func restart_game():
	isRestart = true
	self.current_hp = MAX_HP
	self.current_ammo = MAG_SIZE
	await get_tree().create_timer(2.0).timeout
	isRestart = false
	get_tree().change_scene_to_file("res://scenes/world.tscn")
