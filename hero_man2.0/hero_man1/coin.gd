extends Area2D

@export var rotation_speed: float = 90.0 # درجة/ثانية
@export var bob_height: float = 5.0      # كم تطلع وتنزل بالبكسل
@export var bob_speed: float = 2.0       # سرعة الحركة العمودية

var base_y: float = 0.0
var time_passed: float = 0.0

func _ready():
	base_y = position.y

func _process(delta: float) -> void:
	# دوران ناعم (حول Z في 2D)
	rotation_degrees += rotation_speed * delta

	# صعود وهبوط ناعم
	time_passed += delta
	position.y = base_y + sin(time_passed * bob_speed) * bob_height

func _on_coin_entered(area: Area2D) -> void:
	queue_free()
