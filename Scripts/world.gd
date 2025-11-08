extends Node2D

@onready var player: CharacterBody2D = $ActorsContainer/Player
@onready var camera: Camera2D = $Camera

func _physics_process(_delta: float) -> void:
	handle_move_sync()

# 处理相机与玩家同步问题
func handle_move_sync() -> void:
	# 如果超出场景右边界 340,则相机位置不变
	if (camera.position.x > 340):
		return
	if (camera.position.x < player.position.x):
		camera.position.x = player.position.x
