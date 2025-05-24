extends CharacterBody2D

const MOVE_DISTANCE := 60
const SPEED := 150.0

var direction := 1
var start_x := 0.0
var is_dead := false

func _ready():
	start_x = global_position.x
	visible = true
	# هنا نضبط اللون إلى الأحمر (أو أي لون تريده)
	modulate = Color(1, 0, 0)  # 🔴 أحمر كامل (R=1, G=0, B=0)
	# أو يمكنك استخدام:
	# modulate = Color(0.8, 0.2, 0.2)  # أحمر داكن
	# modulate = Color(1, 0.5, 0.5)  # أحمر فاتح
	# modulate = Color(0.5, 0, 0)  # أحمر غامق

func _physics_process(delta):
	if is_dead:
		return

	var target_x = start_x + (direction * MOVE_DISTANCE)

	if (direction == 1 and global_position.x >= target_x) or (direction == -1 and global_position.x <= target_x):
		direction *= -1

	velocity.x = SPEED * direction
	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is CharacterBody2D:
			var player = collision.get_collider()
			if player.name == "player":
				var normal = collision.get_normal()
				if normal.y > 0.5:
					die_gracefully()
				else:
					player.die()

func die_gracefully():
	if is_dead:
		return
	is_dead = true
	direction = 0
	velocity.x = 0

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(queue_free)
