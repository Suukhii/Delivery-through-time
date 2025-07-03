extends Node2D

@export var player_scene: PackedScene  # Assign your player scene in the Inspector

func _ready():
	var player = player_scene.instantiate()
	add_child(player)

	var spawn_point = $PlayerSpawn
	player.global_position = spawn_point.global_position
