extends Node

const MAX_HP: float = 100.0
const MAX_DNA: float = 500.0
const MAG_SIZE: int = 60 
const MAX_TIME: float = 10.0
const DAMAGE : float = 10.0
const KNOCKBACK : float = 500.0
var is_game_over : bool = false
var chasing_count : int = 0
var isRestart :bool = false
var current_hp: float = 100.0:
	set(value):
		current_hp = clamp(value, 0, MAX_HP)
		SignalBus.hp_changed.emit(current_hp)
			
var current_dna : float = 0.0:
	set(value):
		if is_game_over:
			return
		current_dna = clamp(value, 0, MAX_DNA)
		SignalBus.dna_changed.emit(current_dna)
		if current_dna >= MAX_DNA:
			is_game_over = true
			var time_left = MAX_TIME - current_time
			
			if time_left >= 60.0:
				SignalBus.game_ended.emit("easter_egg")
			else:
				SignalBus.game_ended.emit("normal_ending")

var current_time : float = 0.0:
	set(value):
		current_time = clamp(value, 0, MAX_TIME)
		SignalBus.timer_endgame.emit(current_time)
		if current_time >= MAX_TIME:
			#print("waktu habis")
			#restart_game()
			pass

var current_ammo: int = MAG_SIZE:
	set(value):
		current_ammo = max(0, value)
		SignalBus.ammo_changed.emit(current_ammo)
