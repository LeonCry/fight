extends CharacterBody2D

@export var speed: float
@export var health: int
@export var damage: int
@onready var character_sprite: Sprite2D = $CharacterSprite
@onready var animation_player = $AnimationPlayer
@onready var damage_emitter: Area2D = $DamageEmitter
var STATE = {
	"IDLE": "idle",
	"WALK": "walk",
	"ATTACK": "punch",
}
var current_state = STATE["IDLE"]

func _ready() -> void:
	damage_emitter.area_entered.connect(on_damage_emitter.bind())

func _physics_process(delta: float) -> void:
	handle_input(delta)
	self_Flip()
	self_animation()
	move_and_slide()

# 移动
func handle_input(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed * delta
	if can_attack() and Input.is_action_pressed("attack"):
		current_state = STATE["ATTACK"]


# 处理动画
func self_animation() -> void:
	if can_move():
		if velocity == Vector2.ZERO:
			current_state = STATE["IDLE"]
		else:
			current_state = STATE["WALK"]
	else:
		velocity = Vector2.ZERO
		current_state = STATE["ATTACK"]
	animation_player.play(current_state)

# 处理翻转
func self_Flip() -> void:
	if velocity.x < 0:
		character_sprite.flip_h = true
		damage_emitter.scale.x = -1
	elif velocity.x > 0:
		character_sprite.flip_h = false
		damage_emitter.scale.x = 1

# 是否可以移动
func can_move() -> bool:
	return current_state == STATE["IDLE"] or current_state == STATE["WALK"]

# 是否可以攻击
func can_attack() -> bool:
	return current_state == STATE["IDLE"] or current_state == STATE["WALK"]

# 攻击结束事件监听
func on_attack_finished() -> void:
	current_state = STATE["IDLE"]

# 处理伤害事件
func on_damage_emitter(dr: DamageReceiver) -> void:
	var direction = Vector2.LEFT if dr.global_position.x < global_position.x else Vector2.RIGHT
	dr.damage_received.emit(damage, direction)
