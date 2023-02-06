extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Button_pressed():
	print("pressed")
	get_tree().change_scene("res://scenes/game/main/Node2D.tscn")
	pass # Replace with function body.

func _on_Button_button_up():
	print("up")
	pass # Replace with function body.
