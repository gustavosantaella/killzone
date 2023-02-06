extends CanvasLayer

export (NodePath) var player_node
onready var player = get_node(player_node)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _process(_delta):
	$bar.value = player.health
	if player.health == 0:
		player.is_dead = true
		return



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
