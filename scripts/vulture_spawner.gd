extends Node2D

var preloadedEnemy = preload("res://scenes/vulture.tscn")

@onready var spawnTimer = $SpawnTimer

var nextSpawnTime = 15

# start timer on start
func _ready():
	randomize()
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
