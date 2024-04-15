extends State

func enter(params := {}) -> void:
    if params.has("land"):
        fighter.animation.play(&"LAND")
    fighter.animation.play(&"IDLE_FIGHT")

func update(_delta: float) -> void:

    if (
        not state_machine.controller.motion[Constants.Motions.MOVE] and
        not fighter.hurtbox.knockback
    ):
        owner.velocity.x = 0.0

    if state_machine.controller.motion[Constants.Motions.MOVE]:
        state_machine.transition_to("MOVE")
    if state_machine.controller.motion[Constants.Motions.AIR]:
        state_machine.transition_to("AIR", {do_jump = true})
    if state_machine.controller.motion[Constants.Motions.CROUCH]:
        state_machine.transition_to("CROUCH")
