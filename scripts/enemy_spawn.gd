extends Node2D


func _ready() -> void:
	for i in range(29):
		var enemy = EnemyPoolManager.get_enemy()
	pass 


func _physics_process(delta: float) -> void:
	pass
