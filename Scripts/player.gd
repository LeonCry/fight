class_name Player
extends Character

func handle_input(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if can_move():
		velocity = direction * speed * delta
		current_state = STATE["IDLE"] if velocity == Vector2.ZERO else STATE["WALK"]
	if can_attack() and Input.is_action_pressed("attack"):
		velocity = Vector2.ZERO
		current_state = STATE["ATTACK"]
	if can_jump() and Input.is_action_pressed("jump"):
		current_state = STATE["JUMP_READY"]
	if can_jump_kick() and Input.is_action_pressed("attack"):
		current_state = STATE["JUMP_KICK"]
