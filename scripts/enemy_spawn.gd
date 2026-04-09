extends Node2D


func _ready() -> void:
	await get_tree().process_frame
	for i in range(1):
		var enemy = EnemyPoolManager.get_enemy()
		if enemy == null:
			print("Pool habis! Tidak bisa memunculkan musuh lagi.")
			break


func _physics_process(delta: float) -> void:
	pass
