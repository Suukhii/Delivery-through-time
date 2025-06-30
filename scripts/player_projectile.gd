extends Area2D

@export var speed := 500.0

var direction := Vector2.RIGHT  # Default direction

func _physics_process(delta):
	position += direction * speed * delta

func _on_area_entered(area):
	queue_free()  # Remove bullet on hit 
	
# Removes projectile when off screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
