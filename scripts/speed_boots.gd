extends Area2D

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.has_method("activate_speed_boost"):
		body.activate_speed_boost()
		queue_free()  # Remove the power-up after it's picked up
