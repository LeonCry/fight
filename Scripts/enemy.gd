class_name Enemy
extends Character

@export var player: Player

func handle_input(delta: float) -> void:
	if (player != null):
		var direction := (player.position - position).normalized()
		if (player.position - position).length() < 10:
			direction = Vector2.ZERO
		if can_move():
			velocity = direction * speed * delta
			current_state = STATE["IDLE"] if velocity == Vector2.ZERO else STATE["WALK"]
