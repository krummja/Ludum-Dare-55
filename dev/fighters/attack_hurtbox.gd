class_name AttackHurtbox extends Area2D

@export var knockback_x: int = 800
@export var knockback_y: int = 200

var knockback: bool = false
var knockback_timer: SceneTreeTimer

@onready var fighter = owner as Fighter

func _init() -> void:
	collision_layer = 0b0000
	collision_mask = 0b0010

func _ready() -> void:
	area_entered.connect(self._on_area_entered)

func _on_area_entered(hitbox: AttackHitbox) -> void:
	if hitbox == null:
		return

	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
		knockback = true
		knockback_timer = get_tree().create_timer(0.25)
		knockback_timer.timeout.connect(func(): knockback = false)

func _physics_process(_delta: float) -> void:
	if knockback:
		match fighter.controller.facing:
			Constants.Direction.LEFT:
				owner.velocity.y = -knockback_y
				owner.velocity.x = knockback_x
			Constants.Direction.RIGHT:
				owner.velocity.y = -knockback_y
				owner.velocity.x = -knockback_x
