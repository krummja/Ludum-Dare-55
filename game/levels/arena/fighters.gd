class_name Fighters extends Node2D

var bounding_rect: Rect2
var bounding_center: Vector2

var left_fighter: Fighter = null:
	set = set_left_fighter

var right_fighter: Fighter = null:
	set = set_right_fighter

func set_left_fighter(value: Fighter) -> void:
	left_fighter = value

func set_right_fighter(value: Fighter) -> void:
	right_fighter = value

func _ready() -> void:
	bounding_rect = Rect2()

func _process(_delta: float) -> void:
	var left = min(left_fighter.left, right_fighter.left)
	var right = max(left_fighter.right, right_fighter.right)
	var top = min(left_fighter.top, right_fighter.top)
	var bottom = max(left_fighter.bottom, right_fighter.bottom)

	bounding_rect.position = Vector2(left, top)
	bounding_rect.end = Vector2(right, bottom)
	bounding_center = bounding_rect.get_center()
