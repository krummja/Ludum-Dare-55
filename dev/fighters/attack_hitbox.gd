class_name AttackHitbox extends Area2D

@export var damage := 10

func _init() -> void:
    collision_layer = 0b0010
    collision_mask = 0b0000
