extends Area2D

@export var target_scene: PackedScene  # The scene this portal leads to

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Player entered portal. Changing scene.")
		get_tree().change_scene_to_packed(target_scene)
