class_name Character
extends CharacterBody2D

@export var speed: float
@export var health: int
@export var damage: int
# 硬直时间
@export var erect_time: float = 0.5
# 重力加速度
@export var gravity: float
# 跳跃的初始速度
@export var jump_velocity: float
# 当前跳跃的高度
var current_jump_height: float
@onready var character_sprite: Sprite2D = $CharacterSprite
@onready var animation_player = $AnimationPlayer
@onready var damage_emitter: Area2D = $DamageEmitter
@onready var damage_receiver: DamageReceiver = $"DamageReceiver"
var STATE = {
	"IDLE": "idle",
	"WALK": "walk",
	"ATTACK": "punch",
	"JUMP_READY": "jump_ready",
	"JUMP": "jump",
	"JUMP_OVER": "jump_over",
	"JUMP_KICK": "jump_kick",
	"BEATEN": "beaten",
	"DIE": "die"
}
var current_state = STATE["IDLE"]

func _ready() -> void:
	damage_emitter.area_entered.connect(on_damage_emitter.bind())
	damage_receiver.damage_received.connect(on_damage_received)

func _physics_process(delta: float) -> void:
	handle_input(delta)
	handle_jump(delta)
	self_Flip()
	animation_player.play(current_state)
	move_and_slide()

func _process(_delta: float) -> void:
	check_health()

# 检查健康状态
func check_health() -> void:
	if health <= 0:
		var timer := get_tree().create_timer(0.5)
		current_state = STATE["DIE"]
		create_tween().tween_property(self, "modulate:a", 0, 0.5)
		timer.connect("timeout", func():
			queue_free()
		)

# 移动
func handle_input(_delta: float) -> void:
	pass

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
	return [STATE["IDLE"], STATE["WALK"]].has(current_state)

# 是否可以攻击
func can_attack() -> bool:
	return current_state == STATE["IDLE"] or current_state == STATE["WALK"]

# 是否可以跳跃
func can_jump() -> bool:
	return [STATE["IDLE"], STATE["WALK"]].has(current_state)

# 是否可以跳踢
func can_jump_kick() -> bool:
	return current_state == STATE["JUMP"]

# 跳跃的高度的处理
func handle_jump(delta: float) -> void:
	if [STATE["JUMP"], STATE["JUMP_KICK"]].has(current_state):
		velocity.y += gravity * delta
		current_jump_height += velocity.y * delta
		if current_jump_height >= -0.0:
			current_state = STATE["JUMP_OVER"]


# 攻击结束事件监听
func on_attack_finished() -> void:
	current_state = STATE["IDLE"]

# 处理伤害事件
func on_damage_emitter(dr: DamageReceiver) -> void:
	var direction = Vector2.LEFT if dr.global_position.x < global_position.x else Vector2.RIGHT
	dr.damage_received.emit(damage, direction)

# 跳跃准备结束事件
func on_jump_ready_finished() -> void:
	current_state = STATE["JUMP"]
	velocity.y = jump_velocity
	current_jump_height = 0

#跳跃结束事件
func on_jump_over_finished() -> void:
	current_state = STATE["IDLE"]


# 伤害接收
var beaten_amount: int = 0
func on_damage_received(amount: int, _direction: Vector2) -> void:
	var beaten_time := get_tree().create_timer(erect_time)
	health -= amount
	if (health >= 0):
		beaten_amount += 1
		current_state = STATE["BEATEN"]
		velocity = Vector2.ZERO

	beaten_time.connect("timeout", func():
		beaten_amount -= 1
		if beaten_amount <= 0:
			current_state = STATE["IDLE"]
	)
	print(health)
