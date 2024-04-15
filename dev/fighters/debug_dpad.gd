extends Control

var inactive: TextureRect

@onready var up: TextureRect = $up
@onready var down: TextureRect = $down
@onready var left: TextureRect = $left
@onready var right: TextureRect = $right

var state = {
    up: false,
    down: false,
    left: false,
    right: false,
}

func set_state(direction: String, value: bool) -> void:
    state[direction] = value

func _process(_delta: float) -> void:
    up.visible = state["up"]
    down.visible = state["down"]
    left.visible = state["left"]
    right.visible = state["right"]
