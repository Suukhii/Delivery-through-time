extends Area2D

signal picked_up

func _ready() -> void:
	add_to_group("potions")  # Add potion to the 'potions' group for easy access
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		print("Player touched potion")
		emit_signal("picked_up")
		queue_free()
