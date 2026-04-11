extends Node

signal hp_changed(new_hp)
signal ammo_changed(new_count)
signal player_died
signal enemy_hit(damage, attacker_position, knockback_power)
signal timer_endgame(new_time)
signal dna_changed(new_dna)
signal reload_status(is_reloading)
