extends Node

var score: int = 0
var current_lives: int = 3
var unlocked_worlds: Array = [1]
var default_time_world_1: int = 60
var default_time_world_2: int = 30

func reset_game():
	score = 0
	current_lives = 3
	unlocked_worlds = [1]

func unlock_world(world_number: int):
	if not world_number in unlocked_worlds:
		unlocked_worlds.append(world_number)
		save_game()

func save_game():
	var save_data = {
		"score": score,
		"current_lives": current_lives,
		"unlocked_worlds": unlocked_worlds
	}
	var save_file = FileAccess.open("user://savegame.dat", FileAccess.WRITE)
	save_file.store_var(save_data)
	save_file.close()

func load_game():
	if FileAccess.file_exists("user://savegame.dat"):
		var save_file = FileAccess.open("user://savegame.dat", FileAccess.READ)
		var save_data = save_file.get_var()
		save_file.close()
		score = save_data.get("score", 0)
		current_lives = save_data.get("current_lives", 3)
		unlocked_worlds = save_data.get("unlocked_worlds", [1])
