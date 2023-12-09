extends KinematicBody2D

class_name Character

const SPEED: int = 250
const DAMAGE_PER_BULLET: int = 10
const STARTING_HEALTH: int = 50

onready var target: Vector2 = position
onready var icon = find_node("Godot_icon")
onready var chamber = find_node("Chamber")

export var bullet_scene: PackedScene

var user_id: String

var health: int = STARTING_HEALTH
var velocity: Vector2


func _ready():
	var label: Label = find_node("UsernameLabel")
	label.text = user_id


func _physics_process(_delta):
	if position.distance_to(target) > 5:
		velocity = position.direction_to(target) * SPEED
		velocity = move_and_slide(velocity)


remote func _move_event(args):
	target = args


remote func _rotate_event(args):
	icon.rotation += args


remote func _fire_event():
	var bullet: Area2D = bullet_scene.instance()
	bullet.fire_dir = Vector2(0, 1).rotated(icon.rotation)
	bullet.position = position
	bullet.fired_from = get_network_master()

	get_parent().call_deferred("add_child", bullet)


func take_damage():
	health -= DAMAGE_PER_BULLET
	print_debug("player ", name, " has been hit")

	if ServerManager.is_server() && health <= 0:
		print_debug("player ", name, " killed on server")
		rpc("_player_killed")
		_player_killed()


# TODO: This should disappear the player temporarily, turn off collisions as well, all on a timer
remote func _player_killed():
	visible = false
	yield(get_tree().create_timer(3.0), "timeout")
	health = STARTING_HEALTH
	visible = true


