extends KinematicBody2D

onready var enemy := $Player
var velocity : Vector2
var direction : Vector2

export var pixel_by_m := 20
export var health := 100
export var player_node:NodePath
onready var player = get_node(player_node)
onready var node_copy = self.duplicate()



var is_attack = false
var is_dead = false

var fast := 3 * pixel_by_m

export var damage := 50


# Called when the node enters the scene tree for the first time.
func _ready():
	enemy.play("initial")
	enemy.get_parent().position.x = rand_range(-200, 500)
	fast = rand_range(3,10) * pixel_by_m
	damage = rand_range(3, 20)
	pass # Replace with function body.


func _physics_process(_delta):
	if is_dead:
		direction.x = 0
		return
	velocity.x = direction.x * fast
	velocity = move_and_slide(velocity)

	
func _process(_delta):
	if !node_copy:
		node_copy = self.duplicate()
	if player.is_dead:
		enemy.play("initial")

func _on_Area2D_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	if _area.get_parent().is_in_group('players'):
		if _local_shape_index == 1:
			followPlayer()
			
		if _local_shape_index == 0:
			is_attack = true
			attack()
		 # Replace with function body.

func attack():
	if is_attack == false or is_dead:
		return
	player.damage(damage)
	if player.direction.x == 0:
		yield(get_tree().create_timer(1.5), "timeout")
		return attack()

func _on_Area2D_area_shape_exited(_area_rid, _area, _area_shape_index, _local_shape_index):
	if is_dead:
		return
		
	if _local_shape_index == 1:
		enemy.play("initial")
		direction.x = 0
	else:
		is_attack = false

func followPlayer():
	if is_dead:
		return 
	direction = (player.position - position).normalized()
	enemy.flip_h = !(direction.x > 0 )
	enemy.play("run")
	
func damage(value:float):
	if health == 0 and !is_dead: 
		print('Ememy is dead')
		is_dead = true
		enemy.get_parent().get_node("CollisionShape2D").disabled = true
		enemy.play("dead")
		yield(get_tree().create_timer(1), 'timeout')
		self.get_parent().add_child(node_copy, true)
		node_copy = null
		health = 0
		
		return
	health -= value
	
	print('Health enemy:', health)
	

