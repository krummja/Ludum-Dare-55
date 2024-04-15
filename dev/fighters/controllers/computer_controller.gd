class_name ComputerController extends BaseController

@export var is_enabled: bool = true

@export_category("Movement")
@export var max_distance = 600
@export var flip_offset = 20

@export_category("Logic")
@export var max_action_choice_time = 1.2
@export var max_motion_time = 1.2
@export var max_move_time = 1

@export_range(0.0, 1.0, 0.05) var standoffishness = 0.5
@export_range(0.0, 1.0, 0.05) var defensiveness = 0.5
@export_range(0.0, 1.0, 0.05) var aggressiveness = 0.5
@export_range(0.0, 1.0, 0.05) var jumpiness = 0.5

@export_category("Moveset")
@export_range(0.0, 1.0, 0.05) var punch_kick_threshold = 0.5

@onready var owner_fighter = owner as Fighter

var action_countdown = max_action_choice_time
var motion_countdown = max_motion_time
var move_time = max_move_time
var distance_to: float = 0.0

var _punch_kick_threshold := int(punch_kick_threshold * 100)
var _standoffishness := int(standoffishness * 100)
var _defensiveness := int(defensiveness * 100)
# var _aggressiveness := int(aggressiveness * 100)
# var _jumpiness := int(jumpiness * 100)

var opponent_motion_state: Dictionary
var opponent_action_state: Constants.Actions
var opponent_left_move: float
var opponent_right_move: float

func _ready() -> void:
    set_process(is_enabled)
    owner.add_to_group("Computer")

func _process(delta: float) -> void:
    if owner_fighter == null:
        return

    _observe_opponent()
    _face_opponent()

    action = Constants.Actions.IDLE
    motion[Constants.Motions.AIR] = false
    motion[Constants.Motions.CROUCH] = false

    if (
        opponent_action_state == Constants.Actions.PUNCH ||
        opponent_action_state == Constants.Actions.KICK
    ):
        if _roll_random() <= _defensiveness:
            action = Constants.Actions.BLOCK

    # Decrement the action countdown - at zero, choose an action
    action_countdown -= delta
    if action_countdown < 0:
        var attacked = _try_attack()
        if not attacked:
            _choose_motion()

            if motion[Constants.Motions.MOVE]:
                if _roll_random() <= _standoffishness:
                    match facing:
                        Constants.Direction.LEFT:
                            self.left_move = 1
                            self.right_move = 0
                        Constants.Direction.RIGHT:
                            self.left_move = 0
                            self.right_move = 1
                else:
                    match facing:
                        Constants.Direction.LEFT:
                            self.left_move = 0
                            self.right_move = 1
                        Constants.Direction.RIGHT:
                            self.left_move = 1
                            self.right_move = 0

    if motion[Constants.Motions.MOVE] && move_time > 0:
        move_time -= delta

    else:
        move_time = max_move_time
        self.left_move = 0
        self.right_move = 0

func _face_opponent() -> void:
    distance_to = owner_fighter.opponent.position.x - owner_fighter.position.x
    if distance_to > flip_offset:
        owner_fighter.scale.x = owner_fighter.scale.y * -1
        facing = Constants.Direction.LEFT
    elif distance_to < -flip_offset:
        owner_fighter.scale.x = owner_fighter.scale.y * 1
        facing = Constants.Direction.RIGHT

func _choose_motion() -> bool:
    var result: bool = false

    # MOVE
    # Movement should be towards the player to close distance for attacking,
    # or away from the player to gain distance for defending.
    # This can be controlled by an `standoffishness` threshold.
    # It is influenced by the `aggressiveness` and `defensiveness` values.
    var move_chance = _compute_move_chance()
    if _roll_random() <= move_chance:
        motion[Constants.Motions.MOVE] = true
        result = true

    # Reset the motion countdown
    motion_countdown = max_motion_time
    return result

func _try_attack() -> bool:
    # If random roll (0-100) is good enough for attack, perform attack.

    var result: bool = false

    var attack_chance = _compute_attack_chance()
    if _roll_random() <= attack_chance:

        result = true

        # if roll < 50, punch
        # if roll >= 50, kick
        if _roll_random() <= _punch_kick_threshold:
            action = Constants.Actions.PUNCH
        else:
            action = Constants.Actions.KICK

    # SPECIAL!
    # Special is determined by its own metered variable

    # SPECIAL

    # Reset the action countdown
    action_countdown = max_action_choice_time
    return result

func _observe_opponent() -> void:
    if owner_fighter.opponent == null:
        return
    opponent_action_state = owner_fighter.opponent.controller.action
    opponent_motion_state = owner_fighter.opponent.controller.motion

func _compute_attack_chance() -> float:
    var chance = 0.0

    # Calculate a percentage increase with distance
    var chance_per_step = float(100) / float(max_distance)
    # Modify the chance based on the distance
    chance = chance_per_step * abs(distance_to)

    # Invert the scale so that the closer the CPU is to the player, the higher
    # the outcome.
    chance = 100 - clamp(chance, 10, 90)
    return chance

func _compute_move_chance() -> float:
    var chance = 0.0
    # Calculate a percentage increase with distance
    var chance_per_step = float(100) / float(max_distance)
    # Modify the chance based on the distance
    chance = chance_per_step * abs(distance_to)
    return chance

func _roll_random() -> int:
    var value = 0
    var generator = RandomNumberGenerator.new()
    generator.randomize()
    value = generator.randi_range(0, 100)
    return value
