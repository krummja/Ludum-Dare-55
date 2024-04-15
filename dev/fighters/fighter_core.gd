class_name Fighter extends CharacterBody2D

@export var base_health := 100
@export var speed := 500.0
@export var jump_impulse := 1200.0
@export var base_gravity := 4000.0
@export var jump_repeat := 3.0
@export var motion_state: StateMachine
@export var action_state: StateMachine
@export var attack_area: Area2D
@export var character: Character

@onready var collider: CollisionShape2D = $Collision
@onready var attack: Area2D = $Attack as AttackHitbox
@onready var hurtbox: Area2D = $Hurt as AttackHurtbox
@onready var punch_hitbox: CollisionShape2D = $Attack/PUNCH
@onready var kick_hitbox: CollisionShape2D = $Attack/KICK

@onready var controller := $Controller
@onready var sprite_root: Node2D = $Sprite

var animation: AnimatedSprite2D
var opponent: Fighter
var health = base_health

var can_move: bool = true
var jump_timer: float = 0.0

var width: float
var height: float
var left: float
var right: float
var top: float
var bottom: float

func _ready() -> void:
	punch_hitbox.disabled = true
	kick_hitbox.disabled = true

	match character:
		Character.REDD:
			animation = get_node("Sprite/REDD")

	animation.play()

func _physics_process(delta: float) -> void:
	var rect = collider.shape.get_rect()

	width = rect.size.x
	height = rect.size.y
	left = global_transform.origin.x - (width / 2)
	right = global_transform.origin.x + (width / 2)
	top = global_transform.origin.y + height
	bottom = global_transform.origin.y

	velocity.y += base_gravity * delta
	move_and_slide()

	if jump_timer > 0.0:
		jump_timer -= delta

func perform_punch() -> void:
	punch_hitbox.disabled = false
	await get_tree().create_timer(0.1).timeout
	punch_hitbox.disabled = true

func perform_kick() -> void:
	kick_hitbox.disabled = false
	await get_tree().create_timer(0.1).timeout
	kick_hitbox.disabled = true

func take_damage(amount: int) -> void:
	match controller.facing:
		Constants.Direction.LEFT:
			velocity.x = -5
		Constants.Direction.RIGHT:
			velocity.x = 5
	health -= amount

enum Character {
	REDD,
	RYOHEI,
	BILLIE,
	GERTRUDE,
	CHESTER,
	FURY,
}
