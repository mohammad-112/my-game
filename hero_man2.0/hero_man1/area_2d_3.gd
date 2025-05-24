extends Area2D
func _on_area_2d_3_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
