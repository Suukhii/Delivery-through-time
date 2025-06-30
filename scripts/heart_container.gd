extends Control

@onready var hearts = get_children()  # Gets the 3 TextureRects

func _ready():
	var player = get_node("/root/Game/Player")  # Change path to your player node
	player.connect("hit", Callable(self, "_on_player_hit"))
	_reset_hearts()

func _on_player_hit(lives_left):
	if lives_left < hearts.size():
		hearts[lives_left].visible = false

func _reset_hearts():
	for heart in hearts:
		heart.visible = true
