extends Control

func _on_start_pressed():
	get_node("/root/Global").reset_game() # ← أضفنا هذا السطر
	get_tree().change_scene_to_file("res://world_1.tscn")

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://options.tscn")

func _on_exite_pressed():
	get_tree().quit()

func _on_button_4_pressed() -> void:
	get_tree().change_scene_to_file("res://levels.tscn")
