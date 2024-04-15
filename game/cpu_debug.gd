extends Control

@export var cpu: Fighter
@export var motion_state: Label
@export var action_state: Label

func _process(_delta: float) -> void:
	motion_state.text = cpu.motion_state.state.name
	action_state.text = cpu.action_state.state.name
