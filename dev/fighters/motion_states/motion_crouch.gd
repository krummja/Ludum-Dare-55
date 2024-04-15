extends State

func update(_delta: float) -> void:

    # Move while crouching
    var input_direction_x = (
        state_machine.controller.right_move -
        state_machine.controller.left_move
    )

    if fighter.can_move:
        fighter.velocity.x = (fighter.speed / 2) * input_direction_x
    else:
        fighter.velocity.x = 0.0

    if !state_machine.controller.motion[Constants.Motions.CROUCH]:
        state_machine.transition_to("IDLE")
