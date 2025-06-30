extends Area2D

@onready var timer = $Timer
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("You died") # Replace with function body.
		timer.start()



func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
