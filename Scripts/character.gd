extends CharacterBody2D

@export var speed: float
@export var health: int
@export var damage: int
@onready var animation_player = $AnimatedSprite2D

var STATE = {
	"IDLE": "idle",
	"WALK": "walk",
}
var current_state = STATE["IDLE"]

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	self_move(delta)
	self_animation()
	self_Flip()


# 移动
func self_move(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed * delta
	move_and_slide()

# 处理动画
func self_animation() -> void:
	if velocity == Vector2.ZERO:
		current_state = STATE["IDLE"]
	else:
		current_state = STATE["WALK"]
	animation_player.play(current_state)

# 处理翻转
func self_Flip() -> void:
	if velocity.x < 0:
		animation_player.flip_h = true
	else:
		animation_player.flip_h = false