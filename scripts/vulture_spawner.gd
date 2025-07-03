extends Node2D

var preloadedEnemy = preload("res://scenes/vulture.tscn")

@onready var spawnTimer = $SpawnTimer

var nextSpawnTime = 1

var player_node

# start timer on start
func _ready():
	randomize()
	if get_tree().get_current_scene().name == "Game":
		player_node = get_tree().get_root().get_node("Game/Player/Camera2D")
	elif get_tree().get_current_scene().name == "City":
		player_node = get_tree().get_root().get_node("City/PlayerSpawn/Player")
	spawnTimer.start(nextSpawnTime)


func _on_spawn_timer_timeout():
	# get spawn position relative to camera
	var enemy: Vulture = preloadedEnemy.instantiate()
	var cam := get_viewport().get_camera_2d()
	var half_height := get_viewport_rect().size.y / 2
	var top := cam.global_position.y - half_height
	var bottom := cam.global_position.y + half_height
	var yPos := randf_range(top + 10, bottom - 10)
	enemy.position = Vector2(position.x, yPos)
	
	# Spawn vulture
	get_tree().current_scene.add_child(enemy)
	
	# restart timer
	spawnTimer.start(nextSpawnTime)
	
func _physics_process(delta):
	# Move spawn position relative to player
	set_position(player_node.global_position)
	global_position.x += get_viewport_rect().size.x / 2
