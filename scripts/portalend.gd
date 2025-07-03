extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Player entered portal. Quitting game.")
		get_tree().quit()
