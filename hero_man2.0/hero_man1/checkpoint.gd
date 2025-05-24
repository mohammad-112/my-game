extends Area2D

@onready var marker = $Marker2D
var activated = false

func _on_body_entered(body: Node2D):
	if body.name == "player" and not activated:
		activated = true
		body.activate_checkpoint(marker.global_position)
		print("🎯 Checkpoint activated at:", marker.global_position)
