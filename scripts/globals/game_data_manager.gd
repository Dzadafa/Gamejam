extends Node

const  MAX_HP: float = 100.0
const DAMAGE : float = 10.0
const KNOCKBACK : float = 500.0

var isRestart :bool = false
var current_hp: float = 100.0:
	set(value):
		current_hp = clamp(value, 0, MAX_HP)
		SignalBus.hp_changed.emit(current_hp)
		
		if current_hp <= 0:
			restart_game()

var ammo: int = 30:
	set(value):
		ammo = max(0, value)
		SignalBus.ammo_changed.emit(ammo)

func restart_game():
	isRestart = true
	self.current_hp = MAX_HP
	self.ammo = 30
	await get_tree().create_timer(2.0).timeout
	isRestart = false
	get_tree().change_scene_to_file("res://scenes/world.tscn")
