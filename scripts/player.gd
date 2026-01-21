extends CharacterBody2D
const WIND_SLASH = preload("uid://pn1qw2en7ehx")

enum PlayerState {
	IDLE,
	RUN,
	JUMP,
	FALL,
	ATTACK
}

var state: PlayerState = PlayerState.IDLE

var is_attacking := false
var facing_dir := 1



const SPEED = 130.0
const JUMP_VELOCITY = -300.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var slash_spawn: Marker2D = $SlashSpawn


func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Input
# Input
	var direction := Input.get_axis("move_left", "move_right")

	if not is_attacking:
	# Flip sprite
		if direction > 0:
			facing_dir = 1
			animated_sprite.flip_h = false
		elif direction < 0:
			facing_dir = -1
			animated_sprite.flip_h = true

	# Horizontal movement
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = 0

	if Input.is_action_just_pressed("attack") and not is_attacking:
		start_attack()

	# State & animation
	update_state(direction)
	update_animation()

	move_and_slide()


# Deicde witch state the player is in

func update_state(direction: float) -> void:
	if is_attacking:
		state = PlayerState.ATTACK
		return

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
		PlayerState.ATTACK:
			animated_sprite.play("attack")
			
func start_attack() -> void:
	is_attacking = true
	state = PlayerState.ATTACK

	var slash = WIND_SLASH.instantiate()
	
	# Offset in front of the player depending on facing direction
	var offset := Vector2(20 * facing_dir, -8) # adjust 24 to how far in front you want
	slash.global_position = global_position + offset
	
	# Flip slash based on player direction
	slash.scale.x = facing_dir

	get_parent().add_child(slash)

	await get_tree().create_timer(0.2).timeout
	is_attacking = false
