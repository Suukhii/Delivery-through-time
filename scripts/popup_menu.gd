extends MarginContainer

@export var menu_screen: VBoxContainer
@export var open_menu_screen: MarginContainer
@export var options_screen: MarginContainer


func toggle_visibility(object):
	if object.visible:
		object.visible = false
	else:
		object.visible = true
		

func _input(event):
	if event.is_action_pressed("pauseOrSettings"):
		toggle_visibility(menu_screen)
		toggle_visibility(open_menu_screen)
		if options_screen.visible:
			toggle_visibility(options_screen)


func _on_settings_pressed() -> void:
	toggle_visibility(menu_screen)
	toggle_visibility(open_menu_screen)


func _on_resume_pressed() -> void:
	toggle_visibility(menu_screen)
	toggle_visibility(open_menu_screen)
	
	
func _on_options_pressed() -> void:
	toggle_visibility(options_screen)
	

func _on_back_pressed() -> void:
	toggle_visibility(options_screen)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_resolutions_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_size(Vector2i(1280, 720))


func _on_window_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
