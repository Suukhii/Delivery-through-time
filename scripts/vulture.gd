extends CharacterBody2D

class_name Vulture

var SPEED = 200.0
var health = 50

func _ready() -> void:
	randomize()
	SPEED += randf_range(0, SPEED/4)
	var sprite = $Sprite2D  # or get_node("Sprite2D")
	if get_tree().get_current_scene().name == "Game":
		var new_texture = preload("res://assets/sprites/Map/Egypt/Vulture.png")
		sprite.texture = new_texture
	elif get_tree().get_current_scene().name == "City":
		var new_texture = preload("res://assets/sprites/Map/City/pidgeon.png")
		sprite.texture = new_texture
	elif get_tree().get_current_scene().name == "Space":
		var new_texture = preload("res://assets/sprites/Map/space/evil_cenivel_birb.png")
		sprite.texture = new_texture
	

func _physics_process(delta: float) -> void:
	velocity.x = -SPEED
	move_and_slide()
	
func take_damage(amount):
	health -= amount
	if health <= 0:
		queue_free()
		
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
