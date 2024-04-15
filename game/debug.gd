extends Control

@export var player: Fighter
@export var motion_state: Label
@export var action_state: Label
@export var x_button: Control
@export var y_button: Control
@export var a_button: Control
@export var b_button: Control
@export var d_pad: Control

func _process(_delta: float) -> void:
	motion_state.text = player.motion_state.state.name
	action_state.text = player.action_state.state.name

	if Input.is_action_pressed("PUNCH"):
		a_button.set_active()
	else:
		a_button.set_inactive()

	if Input.is_action_pressed("KICK"):
		b_button.set_active()
	else:
		b_button.set_inactive()

	if Input.is_action_pressed("BLOCK"):
		x_button.set_active()
	else:
		x_button.set_inactive()

	if Input.is_action_pressed("SPECIAL"):
		y_button.set_active()
	else:
		y_button.set_inactive()

	if Input.is_action_pressed("UP"):
		d_pad.set_state("up", true)
	else:
		d_pad.set_state("up", false)

	if Input.is_action_pressed("DOWN"):
		d_pad.set_state("down", true)
	else:
		d_pad.set_state("down", false)

	if Input.is_action_pressed("LEFT"):
		d_pad.set_state("left", true)
	else:
		d_pad.set_state("left", false)

	if Input.is_action_pressed("RIGHT"):
		d_pad.set_state("right", true)
	else:
		d_pad.set_state("right", false)
