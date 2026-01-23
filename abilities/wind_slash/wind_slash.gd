extends Area2D

@export var damage := 1
@export var lifetime := 0.15

func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.take_damage(damage)
