extends CharacterBody2D

class_name Vulture

var SPEED = 200.0
var health = 1

func _ready() -> void:
	randomize()
	SPEED += randf_range(0, SPEED/4)

func _physics_process(delta: float) -> void:
	velocity.x = -SPEED
	move_and_slide()
	
func damage():
	health -= 1
	if health <= 0:
		queue_free()
		
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
