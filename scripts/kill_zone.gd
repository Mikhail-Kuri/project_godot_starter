extends Area2D


# Called when the node enters the scene tree for the first time.
@onready var timer: Timer = $Timer




	
func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		print("u died!")
		body.get_node("CollisionShape2D").queue_free()
		Engine.time_scale = 0.3
		timer.start()



func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
