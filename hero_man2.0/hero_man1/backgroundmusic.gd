extends AudioStreamPlayer

func _ready():
	var music = load("res://backgroundmusic.mp3")  # تأكد من المسار الصحيح
	if music is AudioStream:
		music.loop = true  # تفعيل التكرار داخل الصوت
	stream = music
	volume_db = -12
	play()
