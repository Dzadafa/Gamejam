extends Node2D


func _ready() -> void:
	await get_tree().process_frame
	for i in range(100):
		var enemy = EnemyPoolManager.get_enemy()
		if enemy == null:
			print("Pool enemy habis")
			break


func _physics_process(delta: float) -> void:
	pass
