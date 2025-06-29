extends CharacterBody2D

@export var projectile_scene: PackedScene

@onready var animated_sprite = $AnimatedSprite2D
@onready var projectile_spawn_right = $PlayerProjectileSpawnRight
@onready var projectile_spawn_left = $PlayerProjectileSpawnLeft

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var facing_direction := 1  # 1 = right, -1 = left

func _input(event):
	if event.is_action_pressed("shoot_player_projectile"):
		shoot_projectile()
	
	if event.is_action_pressed("move_right"):
		facing_direction = 1
	
	if(event.is_action_pressed("move_left")):
		facing_direction = -1


func shoot_projectile():
	if projectile_scene:
		var projectile = projectile_scene.instantiate()
		
		if facing_direction == 1:
			projectile.global_position = projectile_spawn_right.global_position
		else:
			projectile.global_position = projectile_spawn_left.global_position
			
		projectile.direction = Vector2(facing_direction, 0)
		get_tree().current_scene.add_child(projectile)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	if direction:
		velocity.x = direction * SPEED
		animated_sprite.play("move")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite.play("idle")
	move_and_slide()
	
	
	if not is_on_floor():
		animated_sprite.play("jump")
	elif direction:
		animated_sprite.play("move")
	else:
		animated_sprite.play("idle")
