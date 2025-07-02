extends MarginContainer

@export var menu_screen: VBoxContainer
@export var open_menu_screen: MarginContainer
@export var open_options_screen: MarginContainer


func toggle_visibility(object):
	if object.visible:
		object.visible = false
	else:
		object.visible = true
		

func _input(event):
	if event.is_action_pressed("pauseOrSettings"):
		toggle_visibility(menu_screen)
		toggle_visibility(open_menu_screen)
		if open_options_screen.visible:
			toggle_visibility(open_options_screen)


func _on_settings_pressed() -> void:
	toggle_visibility(menu_screen)
	toggle_visibility(open_menu_screen)


func _on_resume_pressed() -> void:
	toggle_visibility(menu_screen)
	toggle_visibility(open_menu_screen)
	
	
func _on_options_pressed() -> void:
	toggle_visibility(open_options_screen)


func _on_quit_pressed() -> void:
	get_tree().quit()
