extends KinematicBody2D


onready var player := $Player
var velocity : Vector2
var direction : Vector2

export var jump_time  := 0.3
export var pixel_by_m := 67
export var health := 100
export var damage :=10

var is_jumping:bool = false
var is_shooting:bool = false
var is_dead:bool = false
var can_be_attack:bool= false

var jump_distance = 2 * pixel_by_m
var jump_force = (-2 * jump_distance) / jump_time
var fast := 3.5 * pixel_by_m
var GRAVITY = (2 * jump_distance) / pow(jump_time, 2)
var enemy = null

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("Player")
	player.play("initial")
	pass # Replace with function body.

func _input(event):
	if is_dead != false:
		return
	move_player(event)
	shoot()
	
func _physics_process(delta):
	velocity.y += delta * GRAVITY
	velocity.x = direction.x * fast
	if is_on_floor():
		is_jumping = false
	else:
		is_jumping = true
	velocity = move_and_slide(velocity, Vector2(0, -1))

func move_player(event:InputEvent):
	direction = Vector2.ZERO
	direction.x = Input.get_axis("left", "right")
	if event.is_action_pressed('jump') and is_jumping == false:
		velocity.y = jump_force
	if direction.x != 0:
		player.play("run")
		player.flip_h = !(direction.x > 0 )
	elif !is_shooting and !is_dead:
		player.play("initial")
	direction = direction.normalized()

func shoot():
	var is_pressed = Input.is_action_pressed("ui_accept")
	if is_pressed and !is_shooting:
		is_shooting = true
		player.play("shoot")
	elif !is_pressed and is_shooting:
		is_shooting = false
		player.play("initial")
	if enemy and is_shooting:
			enemy.damage(damage)
		
func damage(value):
	health -= value
	if health <= 0 and !is_dead:
		print("Player is dead")
		is_dead = true
		player.play("dead")
		health = 0
		return
	
func _process(_delta):
	if is_dead:
		player.play("dead")

func _on_Area2D_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	if _area.get_parent().is_in_group("enemies"):
		can_be_attack = true
		enemy = _area.get_parent()

func _on_Area2D_area_exited(area):
	can_be_attack = false
	enemy = null
