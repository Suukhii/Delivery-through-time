extends CharacterBody2D

@export var projectile_scene: PackedScene

@onready var animated_sprite = $AnimatedSprite2D
@onready var projectile_spawn_right = $PlayerProjectileSpawnRight
@onready var projectile_spawn_left = $PlayerProjectileSpawnLeft


signal hit

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const GRAVITY = 1000
const FALL_GRAVITY = 1600

var facing_direction := 1  # 1 = right, -1 = left
var is_throwing := false

func _input(event):
	if event.is_action_pressed("move_right"):
		facing_direction = 1

	if event.is_action_pressed("move_left"):
		facing_direction = -1
		
	if event.is_action_pressed("shoot_player_projectile"):
		shoot_projectile_with_throw()


func shoot_projectile_with_throw() -> void:
	if is_throwing or projectile_scene == null:
		return

	is_throwing = true
	animated_sprite.play("throw")

	await animated_sprite.animation_finished  # Wait for the animation to finish

	var projectile = projectile_scene.instantiate()

	if facing_direction == 1:
		projectile.global_position = projectile_spawn_right.global_position
	else:
		projectile.global_position = projectile_spawn_left.global_position

	projectile.direction = Vector2(facing_direction, 0)
	get_tree().current_scene.add_child(projectile)

	is_throwing = false
	
	
func return_gravity(velocity: Vector2):
	if velocity.y < 0:
		return GRAVITY
	return FALL_GRAVITY


func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity.y += return_gravity(velocity) * delta
		
	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Makes jump pressure sensitive
	if Input.is_action_just_released("jump") and velocity.y < 0 and velocity.y < JUMP_VELOCITY/4:
		velocity.y = JUMP_VELOCITY / 4

	# Movement
	var direction := Input.get_axis("move_left", "move_right")
		

	# Sprite facing
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Horizontal movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Stop movement during throwing
	if is_throwing:
		move_and_slide()
		return
		
	move_and_slide()

	# Animation logic
	if not is_on_floor():
		animated_sprite.play("jump")
	elif direction:
		animated_sprite.play("move")
	else:
		animated_sprite.play("idle")
		
var lives := 3

func on_hit():
	lives -= 1
	print("Player hit! Lives left: ", lives)
	emit_signal("hit", lives)  
	if lives <= 0:
		die() 
		
func die():
	print("You died")
	get_tree().reload_current_scene()
	
