extends Sprite2D

func _on_arealevels_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		print (("res://world_" + str(int(get_tree().current_scene.name ) + 1) + ".tcsn"))
		
		get_tree().change_scene_to_file("res://world_" + str(int(get_tree().current_scene.name ) + 1) + ".tcsn")
