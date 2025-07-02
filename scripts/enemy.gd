extends CharacterBody2D

const SPEED = 60
var direction = 1
var health = 100

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	if ray_cast_right.is_colliding():
		var collider = ray_cast_right.get_collider()
		if collider is TileMapLayer:
			direction = -1
			animated_sprite.flip_h = true
		
	if ray_cast_left.is_colliding():
		var collider = ray_cast_left.get_collider()
		if collider is TileMapLayer:
			direction = 1
			animated_sprite.flip_h = false
	position.x += direction * SPEED * delta

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.on_hit()

func take_damage(amount: int) -> void:
	health -= amount
	print("Enemy took ", amount, " damage. Health now: ", health)
	if health <= 0:
		queue_free()
