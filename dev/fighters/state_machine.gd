class_name StateMachine extends Node

signal transitioned(state_name: String)

@export var initial_state := NodePath()
@export var controller: BaseController

@onready var state: State = get_node(initial_state)
@onready var fighter: Fighter = owner as Fighter

func _ready() -> void:
	await owner.ready
	for child in get_children():
		child.state_machine = self
		child.fighter = fighter
	state.enter()

func _process(delta: float) -> void:
	state.update(delta)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)

func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

func transition_to(state_name: String, params: Dictionary = {}) -> void:
	if not has_node(state_name):
		return
	state.exit()
	state = get_node(state_name)
	state.enter(params)
	emit_signal("transitioned", state.name)
