extends CharacterBody2D

@export var projectile_scene: PackedScene

@onready var animated_sprite = $AnimatedSprite2D
@onready var projectile_spawn_right = $PlayerProjectileSpawnRight
@onready var projectile_spawn_left = $PlayerProjectileSpawnLeft

var fire_rate := 5.0  # shots per second (normal)
var boosted_fire_rate := 1000.0  # shots per second when boosted
var is_fire_rate_boosted := false
var shoot_cooldown := 0.0
var fire_rate_timer: Timer

var boosted_speed := 1000.0
var speed_boost_duration := 3.0
var fire_rate_boost_duration := 10.0



var is_speed_boosted := false
var speed_timer: Timer



signal hit

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const GRAVITY = 1000
const FALL_GRAVITY = 1600

var facing_direction := 1  # 1 = right, -1 = left
var is_throwing := false


func _process(delta):
	if shoot_cooldown > 0:
		shoot_cooldown -= delta


func _input(event):
	if event.is_action_pressed("move_right"):
		facing_direction = 1
		
	if event.is_action_pressed("move_left"):
		facing_direction = -1
		
	if event.is_action_pressed("shoot_player_projectile"):
		shoot_projectile_with_cooldown()



func shoot_projectile_with_cooldown():
	if is_throwing or projectile_scene == null:
		return
	
	if shoot_cooldown > 0:
		return  # still cooling down, can't shoot
	
	shoot_cooldown = 1.0 / (boosted_fire_rate if is_fire_rate_boosted else fire_rate)
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
	var current_speed = boosted_speed if is_speed_boosted else SPEED

	if direction:
		velocity.x = direction * current_speed  # <-- Use current_speed here!
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)  # <-- And here!
	
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
	
	
func _ready():
	speed_timer = Timer.new()
	speed_timer.one_shot = true
	speed_timer.wait_time = speed_boost_duration
	speed_timer.connect("timeout", Callable(self, "_on_speed_boost_timeout"))
	add_child(speed_timer)

	fire_rate_timer = Timer.new()
	fire_rate_timer.one_shot = true
	fire_rate_timer.wait_time = fire_rate_boost_duration
	fire_rate_timer.connect("timeout", Callable(self, "_on_fire_rate_boost_timeout"))
	add_child(fire_rate_timer)

	
func activate_speed_boost():
	if is_speed_boosted:
		speed_timer.stop()  # Restart the timer if another power-up is picked up
	speed_timer.start()
	is_speed_boosted = true
	print("Speed boost activated!")
	
func _on_speed_boost_timeout():
	is_speed_boosted = false
	print("Speed boost ended.")
	
	
func activate_fire_rate_boost():
	if is_fire_rate_boosted:
		fire_rate_timer.stop()
	is_fire_rate_boosted = true
	fire_rate_timer.start()
	print("Fire rate boost activated!")

func _on_fire_rate_boost_timeout():
	is_fire_rate_boosted = false
	print("Fire rate boost ended.")
