extends Node2D

func _ready():
	var spawn_point = $PlayerSpawn
	var player = $Player  # Direct reference to the Player node in the scene
	
	if player and spawn_point:
		player.global_position = spawn_point.global_position
	else:
		print("Player or spawn point not found!")
