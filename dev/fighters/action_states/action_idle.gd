extends State

func enter(_params := {}) -> void:
    if fighter.controller.motion[Constants.Motions.IDLE]:
        fighter.animation.play(&"IDLE_FIGHT")

func update(_delta: float) -> void:
    match state_machine.controller.action:
        Constants.Actions.PUNCH:
            state_machine.transition_to("PUNCH")
        Constants.Actions.KICK:
            state_machine.transition_to("KICK")
        Constants.Actions.BLOCK:
            state_machine.transition_to("BLOCK")
        Constants.Actions.SPECIAL:
            state_machine.transition_to("SPECIAL")
