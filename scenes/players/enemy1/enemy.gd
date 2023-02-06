extends KinematicBody2D

onready var enemy := $Player
var velocity : Vector2
var direction : Vector2

export var pixel_by_m := 20
export var health := 100
export var player_node:NodePath
onready var player = get_node(player_node)


var fast := 5 * pixel_by_m


export var damage := 50




# Called when the node enters the scene tree for the first time.
func _ready():
	enemy.play("initial")
	pass # Replace with function body.

"""
func _input(event):
	move_player(event)
	shoot()
	
"""
func _physics_process(_delta):
	velocity.x = direction.x * fast
	velocity = move_and_slide(velocity)

	
func _process(_delta):
	if player.is_dead:
		enemy.play("initial")
"""
func shoot():
	var is_pressed = Input.is_action_pressed("ui_accept")
	if is_pressed and !is_shooting:
		is_shooting = true
		player.play("shoot")
	elif !is_pressed and is_shooting:
		is_shooting = false
		player.play("initial")
		
"""
func _on_Area2D_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	if _local_shape_index == 1:
		direction.x = -1 if player.direction.x == 1 else 1
		if direction.x != 0:
			enemy.play("run")
			enemy.flip_h = !(direction.x > 0 )
		else:
			enemy.play("initial")
	if _local_shape_index == 0:
		enemy.play("attack")
		attack()
	 # Replace with function body.

func attack():
	player.damage(damage)
	if player.direction.x == 0:
		yield(get_tree().create_timer(1.5), "timeout")
		return attack()

func _on_Area2D_area_exited(_area):
	enemy.play("initial")
	direction.x = 0
