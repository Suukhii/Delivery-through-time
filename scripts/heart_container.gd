extends Control

@onready var hearts = get_children()  # Assumes hearts are direct children TextureRects

func _ready():
	var player = get_node("/root/Game/Player")
	player.connect("hit", Callable(self, "_on_player_hit"))
	_reset_hearts()

func _on_player_hit(lives_left):
	for i in range(hearts.size()):
		hearts[i].visible = i < lives_left

func update_hearts(lives_left):
	# Call this when lives increase (or decrease) to update hearts display
	for i in range(hearts.size()):
		hearts[i].visible = i < lives_left

func _reset_hearts():
	for heart in hearts:
		heart.visible = true
