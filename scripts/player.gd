extends CharacterBody2D

enum PlayerState {
	IDLE,
	RUN,
	JUMP,
	FALL
}

var state: PlayerState = PlayerState.IDLE



const SPEED = 130.0
const JUMP_VELOCITY = -300.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Input
	var direction := Input.get_axis("move_left", "move_right")

	# Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Horizontal movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# State & animation
	update_state(direction)
	update_animation()

	move_and_slide()


# Deicde witch state the player is in

func update_state(direction: float) -> void:
	if is_on_floor():
		if direction == 0:
			state = PlayerState.IDLE
		else:
			state = PlayerState.RUN
	else:
		if velocity.y < 0:
			state = PlayerState.JUMP
		else:
			state = PlayerState.FALL

#Based on the state, update the curent animation

func update_animation() -> void:
	match state:
		PlayerState.IDLE:
			animated_sprite.play("Idle")
		PlayerState.RUN:
			animated_sprite.play("run")
		PlayerState.JUMP:
			animated_sprite.play("jump")
		PlayerState.FALL:
			animated_sprite.play("jump")


