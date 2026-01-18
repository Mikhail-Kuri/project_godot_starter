extends Node2D

const SPEED := 60

enum Direction { LEFT = -1, RIGHT = 1 }
var direction: int = Direction.RIGHT

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D



func _physics_process(delta: float) -> void:
	update_direction()
	move(delta)

func update_direction() -> void:
	if ray_cast_right.is_colliding():
		direction = Direction.LEFT
		animated_sprite.flip_h = true
	elif ray_cast_left.is_colliding():
		direction = Direction.RIGHT
		animated_sprite.flip_h = false
	
	

func move(delta: float) -> void:
	position.x += direction * SPEED * delta
