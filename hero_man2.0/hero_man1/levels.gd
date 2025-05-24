extends Control

func _on_button_pressed() -> void:
	get_node("/root/Global").reset_game()
	get_tree().change_scene_to_file("res://world_1.tscn")

func _on_button_2_pressed() -> void:
	get_node("/root/Global").reset_game()
	get_tree().change_scene_to_file("res://world_2.tscn")

func _on_button_3_pressed() -> void:
	get_node("/root/Global").reset_game()
	get_tree().change_scene_to_file("res://world_3.tscn")

func _on_button_4_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
