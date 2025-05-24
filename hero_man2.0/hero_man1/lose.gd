extends Control

func _on_button_pressed() -> void:
	# إعادة المحاولة (تشغيل العالم الأول مباشرة)
	get_node("/root/Global").reset_game()
	get_tree().change_scene_to_file("res://world_1.tscn")

func _on_button_2_pressed() -> void:
	# الرجوع إلى الصفحة الرئيسية - نحتاج نعمل reset هون كمان
	get_node("/root/Global").reset_game()
	get_tree().change_scene_to_file("res://main_menu.tscn")
