extends Control

@onready var hearts = get_children()  # Gets the 3 TextureRects

func _ready():
	var players = get_tree().get_nodes_in_group("Player")  # Searches globally
	if players.size() > 0:
		var player = players[0]
		player.connect("hit", Callable(self, "_on_player_hit"))
		print("Connected to player's hit signal")
	else:
		print("Player not found in group!")
	_reset_hearts()



func _on_player_hit(lives_left):
	if lives_left < hearts.size():
		hearts[lives_left].visible = false

func _reset_hearts():
	for heart in hearts:
		heart.visible = true
