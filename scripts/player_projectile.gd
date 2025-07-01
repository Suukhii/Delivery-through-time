extends Area2D

@export var speed := 500.0

var direction := Vector2.RIGHT  # Default direction

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Enemy"):
		print("Hit Enemy: ", body.name)
		queue_free()
	elif not body.is_in_group("Projectile") and not body.is_in_group("Player"):
		print("Hit: ", body.name)
		queue_free()
# Removes projectile when off screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
