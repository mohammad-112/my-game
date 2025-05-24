extends CharacterBody2D

signal lives_changed(lives: int)

var coin_counter = 0
@onready var coin_label = %Label
@onready var coin_sound = $CoinSound

const SPEED = 200
const ACCELERATION = 50 
const FRICTION = 70
const AIR_RESISTANCE = 20

const JUMP_FORCE = -570
const GRAVITY = 35
const MAX_JUMPS = 2
var current_jumps = 0

var lives = 3
var invincible = false
@onready var invincibility_timer: Timer = $InvincibilityTimer
var lose_scene_path = "res://lose.tscn"

var respawn_position: Vector2
@onready var collision_shape = $CollisionShape2D
@onready var anim_sprite = $AnimatedSprite2D

func _ready():
	respawn_position = global_position
	if invincibility_timer:
		invincibility_timer.timeout.connect(_on_InvincibilityTimer_timeout)
	if coin_sound == null:
		push_warning("⚠️ CoinSound غير مهيأ!")

func _physics_process(_delta):
	var input_dir = get_input_direction()
	apply_movement(input_dir)
	apply_gravity()
	handle_jump()
	flip_sprite(input_dir)
	move_and_slide()
	update_animations(input_dir)

func get_input_direction() -> Vector2:
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis("ui_left", "ui_right")
	return input_dir.normalized()

func apply_movement(input_dir: Vector2):
	if input_dir != Vector2.ZERO:
		var target_speed = input_dir.x * SPEED
		if is_on_floor():
			velocity.x = move_toward(velocity.x, target_speed, ACCELERATION)
		else:
			velocity.x = move_toward(velocity.x, target_speed, ACCELERATION * 0.6)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, FRICTION)
		else:
			velocity.x = move_toward(velocity.x, 0, AIR_RESISTANCE)

func apply_gravity():
	if not is_on_floor():
		velocity.y += GRAVITY
		if velocity.y > 0:
			velocity.y += GRAVITY * 0.2

func handle_jump():
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_FORCE
			current_jumps = 1
		elif current_jumps < MAX_JUMPS:
			velocity.y = JUMP_FORCE * 0.8
			current_jumps += 1

func flip_sprite(direction: Vector2):
	if direction.x > 0:
		anim_sprite.flip_h = true
	elif direction.x < 0:
		anim_sprite.flip_h = false

func update_animations(_input_dir: Vector2):
	if is_on_floor():
		if abs(velocity.x) > 10:
			anim_sprite.play("run")
		else:
			anim_sprite.play("idle")
	else:
		if velocity.y < 0:
			anim_sprite.play("jump")
		else:
			anim_sprite.play("fall")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("coin"):
		coin_counter += 1
		if coin_sound:
			coin_sound.play()
		coin_label.text = "Coin Count: " + str(coin_counter)
		area.queue_free()

func die():
	if invincible:
		return

	lives -= 1
	print("💔 فقد روح. الأرواح المتبقية: ", lives)
	emit_signal("lives_changed", lives)

	if lives <= 0:
		# تأخير بسيط لتفادي أخطاء المشهد
		call_deferred("_go_to_lose_scene")
		return

	# إعادة اللاعب وتفعيل عدم الضرر مؤقتاً
	set_physics_process(false)
	velocity = Vector2.ZERO
	anim_sprite.modulate = Color(0.5, 0.5, 0.5, 1)
	collision_shape.disabled = true

	var tween := get_tree().create_tween()
	tween.tween_property(self, "global_position", respawn_position, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(Callable(self, "_on_respawn_finished"))

	invincible = true
	invincibility_timer.start()

func _go_to_lose_scene():
	if get_tree():
		get_tree().change_scene_to_file(lose_scene_path)

func _on_respawn_finished():
	anim_sprite.modulate = Color(1, 1, 1, 1)
	collision_shape.disabled = false
	velocity = Vector2.ZERO
	set_physics_process(true)

func _on_InvincibilityTimer_timeout():
	invincible = false

func _on_death_zone_area_entered(area):
	if area.is_in_group("danger"):
		die()

func activate_checkpoint(pos: Vector2):
	respawn_position = pos
