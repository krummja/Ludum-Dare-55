extends State

func enter(params := {}) -> void:
    if params.has("land"):
        fighter.animation.play(&"LAND")
    fighter.animation.play(&"MOVE")

func physics_update(_delta: float) -> void:

    if (
        state_machine.controller.motion[Constants.Motions.MOVE] and
        !fighter.animation.is_playing()
    ):
        fighter.animation.play(&"MOVE")

    if state_machine.controller.motion[Constants.Motions.AIR]:
        state_machine.transition_to("AIR", {do_jump = true})
    if state_machine.controller.motion[Constants.Motions.CROUCH]:
        state_machine.transition_to("CROUCH")

    # Move on ground
    var input_direction_x: float = (
        state_machine.controller.right_move -
        state_machine.controller.left_move
    )

    if fighter.can_move:
        fighter.velocity.x = fighter.speed * input_direction_x
    else:
        fighter.velocity.x = 0.0

    if is_equal_approx(input_direction_x, 0.0):
        state_machine.transition_to("IDLE")
