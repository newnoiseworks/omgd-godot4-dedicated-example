extends "res://Character/CharacterController.gd"

# icon from https://www.reddit.com/r/godot/comments/icagss/i_made_a_claylike_3d_desktop_icon_for_godot_ico/

const INPUT_MOVE: int = 20


func _unhandled_input(event):
	if event is InputEventKey:
		if Input.is_action_just_released("fire"):
			rpc_unreliable("_fire_event")
			_fire_event()


func _physics_process(delta):
	var target = position

	if Input.is_action_pressed("move_right"):
		target.x += INPUT_MOVE
	if Input.is_action_pressed("move_left"):
		target.x -= INPUT_MOVE
	if Input.is_action_pressed("move_down"):
		target.y += INPUT_MOVE
	if Input.is_action_pressed("move_up"):
		target.y -= INPUT_MOVE

	if (target.distance_to(position) > INPUT_MOVE - 5):
		rpc_unreliable("_move_event", target)
		_move_event(target)

	if Input.is_action_pressed("rotate_right"):
		rpc_unreliable("_rotate_event", -1.5 * delta)
		_rotate_event(-1.5 * delta)
	if Input.is_action_pressed("rotate_left"):
		rpc_unreliable("_rotate_event", 1.5 * delta)
		_rotate_event(1.5 * delta)


