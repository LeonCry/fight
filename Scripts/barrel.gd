extends StaticBody2D
@export var speed: float = 10.0
@export var height_speed: float = 0
@onready var barrel_Sprite2D: Sprite2D = $Sprite2D
enum State {
	IDLE,
	DESTROYED,
}
var current_state: State = State.IDLE
const MAX_HEIGHT: float = 0.5
var height: float = 0.0
var h_direction: Vector2 = Vector2.UP
var velocity: Vector2 = Vector2.ZERO
@onready var damage_receiver: DamageReceiver = $DamageReceiver
func _ready() -> void:
	damage_receiver.damage_received.connect(on_damage_received.bind())

func _physics_process(delta: float) -> void:
	update_animation()
	print("height: ", height, height_speed)
	position.x += velocity.x * delta
	height += height_speed * delta * h_direction.y
	if height < -MAX_HEIGHT:
		h_direction = Vector2.DOWN
	if height >= MAX_HEIGHT:
		h_direction = Vector2.ZERO
		queue_free()
	position.y += height

func on_damage_received(damage: int, direction: Vector2) -> void:
	if (current_state == State.IDLE):
		current_state = State.DESTROYED
		velocity = direction * speed
		height_speed = 2
		print("barrel damage_received: ", damage, direction)

func update_animation() -> void:
	if (current_state == State.IDLE):
		barrel_Sprite2D.frame = 0
	elif (current_state == State.DESTROYED):
		barrel_Sprite2D.frame = 1