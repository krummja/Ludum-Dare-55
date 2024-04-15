extends State

func enter(params := {}) -> void:
    if params.has("do_jump") and fighter.jump_timer <= 0.0:
        fighter.velocity.y = -fighter.jump_impulse
        fighter.jump_timer = fighter.jump_repeat

    fighter.animation.play(&"JUMP")

func physics_update(_delta: float) -> void:

    # Move in air
    var input_direction_x = (
        state_machine.controller.right_move -
        state_machine.controller.left_move
    )

    if fighter.can_move:
        fighter.velocity.x = fighter.speed * input_direction_x
    else:
        fighter.velocity.x = 0.0

    # Check for ground
    if fighter.is_on_floor():
        if is_equal_approx(fighter.velocity.x, 0.0):
            state_machine.transition_to("IDLE", {land=true})
        else:
            state_machine.transition_to("MOVE", {land=true})
