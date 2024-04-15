extends State

var timer: SceneTreeTimer

var may_exit: bool = false

func enter(_params := {}) -> void:
    fighter.can_move = false
    may_exit = false
    timer = get_tree().create_timer(0.25)
    timer.timeout.connect(func(): may_exit = true)

    fighter.animation.play(&"PUNCH")
    fighter.perform_punch()

func update(_delta: float) -> void:
    if may_exit:
        state_machine.transition_to("IDLE")

func exit() -> void:
    fighter.can_move = true
