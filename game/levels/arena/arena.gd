extends Node2D

signal loaded

@export var fighters: Fighters
@export_file("*.tscn") var left_fighter: String
@export_file("*.tscn") var right_fighter: String

@onready var spawn_left: Marker2D = $SpawnLeft
@onready var spawn_right: Marker2D = $SpawnRight

func _ready() -> void:
	var _left_fighter = NodeLoader.load(left_fighter, $Fighters, "Left")
	var _right_fighter = NodeLoader.load(right_fighter, $Fighters, "Right")

	_left_fighter.position = spawn_left.position
	_right_fighter.position = spawn_right.position

	fighters.left_fighter = _left_fighter
	fighters.right_fighter = _right_fighter

	fighters.left_fighter.opponent = fighters.right_fighter
	fighters.right_fighter.opponent = fighters.left_fighter
