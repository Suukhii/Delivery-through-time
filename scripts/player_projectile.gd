extends Area2D

@export var damage = 50
@export var speed := 500.0
var direction := Vector2.RIGHT  # Default direction

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	print("Hit:", body.name)
	if body.is_in_group("Enemy") and body.has_method("take_damage"):
		body.take_damage(damage)
		print("Hit Enemy: ", body.name)
		queue_free()
	elif not body.is_in_group("Projectile") and not body.is_in_group("Player"):
		print("Hit: ", body.name)
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
