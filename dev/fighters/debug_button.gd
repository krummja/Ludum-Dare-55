extends Control

var active: TextureRect
var inactive: TextureRect

func _ready() -> void:
    active = $active
    inactive = $inactive
    inactive.visible = false

func set_active() -> void:
    active.visible = true
    inactive.visible = false

func set_inactive() -> void:
    active.visible = false
    inactive.visible = true
