class_name PlayerController extends BaseController

func _ready() -> void:
    owner.add_to_group("Player")

func _process(_delta: float) -> void:
    motion[Constants.Motions.IDLE] = true
    motion[Constants.Motions.AIR] = false
    motion[Constants.Motions.MOVE] = false
    motion[Constants.Motions.CROUCH] = false

    if Input.is_action_just_pressed("UP"):
        motion[Constants.Motions.IDLE] = false
        motion[Constants.Motions.AIR] = true
    if Input.is_action_pressed("LEFT") or Input.is_action_pressed("RIGHT"):
        motion[Constants.Motions.IDLE] = false
        motion[Constants.Motions.MOVE] = true
    if Input.is_action_pressed("DOWN"):
        motion[Constants.Motions.IDLE] = false
        motion[Constants.Motions.CROUCH] = true

    if InputBuffer.is_action_press_buffered("PUNCH"):
        action = Constants.Actions.PUNCH
    elif InputBuffer.is_action_press_buffered("KICK"):
        action = Constants.Actions.KICK
    elif InputBuffer.is_action_press_buffered("BLOCK"):
        action = Constants.Actions.BLOCK
    elif InputBuffer.is_action_press_buffered("SPECIAL"):
        action = Constants.Actions.SPECIAL
    else:
        action = Constants.Actions.IDLE

func _physics_process(_delta: float) -> void:
    if action == Constants.Actions.IDLE:
        self.left_move = Input.get_action_strength("LEFT")
        self.right_move = Input.get_action_strength("RIGHT")
