extends Node2D

@onready var countdown_timer: Timer = $CountdownTimer
@onready var timer_label: Label = $CanvasLayer/timer/TimerLabel
@onready var lives_label: Label = $CanvasLayer/LivesLabel
@onready var player = $player
@onready var main_menu_button = $CanvasLayer/Button

var time_left: int
var is_timer_running: bool = true
var level_completed: bool = false

func _ready():
	var global = get_node("/root/Global")
	player.lives = global.current_lives
	time_left = global.default_time_world_1
	update_lives_label(player.lives)
	player.lives_changed.connect(update_lives_label)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)
	initialize_timer()
	update_timer_display()

func initialize_timer():
	countdown_timer.wait_time = 1.0
	countdown_timer.timeout.connect(_on_CountdownTimer_timeout)
	countdown_timer.start()

func _on_CountdownTimer_timeout():
	if not is_timer_running or level_completed:
		return
	time_left -= 1
	update_timer_display()
	if time_left <= 0:
		time_out()

func update_timer_display():
	timer_label.text = "Time: %d" % time_left
	
	# ✅ إضافة: تدرج اللون من أبيض إلى أحمر عندما يكون الوقت <= 10
	if time_left <= 10:
		var t = clamp((10 - time_left) / 10.0, 0, 1)  # النسبة من 0 إلى 1
		var color = Color(1, 1 - t, 1 - t)  # من أبيض إلى أحمر تدريجيًا
		timer_label.add_theme_color_override("font_color", color)
	else:
		timer_label.add_theme_color_override("font_color", Color.WHITE)

func time_out():
	countdown_timer.stop()
	is_timer_running = false
	get_tree().change_scene_to_file("res://lose.tscn")

func update_lives_label(lives: int):
	lives_label.text = "❤️ Lives: %d" % lives
	if has_node("/root/Global"):
		get_node("/root/Global").current_lives = lives
	if lives <= 1:
		lives_label.add_theme_color_override("font_color", Color.RED)
	if lives <= 0:
		get_tree().change_scene_to_file("res://lose.tscn")

# هذه الدالة هي التي تحل الخطأ
func _on_main_menu_button_pressed():
	if has_node("/root/Global"):
		get_node("/root/Global").save_game()
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player.die()

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://world_2.tscn")
