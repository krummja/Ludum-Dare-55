class_name Main extends Node

@export var crt_shader_enabled: bool = true

@onready var crt_overlay := $CanvasLayer

func _process(_delta: float) -> void:
	crt_overlay.visible = crt_shader_enabled
