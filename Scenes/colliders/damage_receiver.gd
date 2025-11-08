class_name DamageReceiver
extends Area2D

# 伤害接收信号
@warning_ignore("unused_signal")
signal damage_received(damage: int, direction: Vector2)
