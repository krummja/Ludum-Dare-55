class_name State extends Node

var state_machine: StateMachine = null
var fighter: Fighter = null


func _ready() -> void:
    await owner.ready

func enter(_params := {}) -> void:
    pass

func handle_input(_event: InputEvent) -> void:
    pass

func update(_delta: float) -> void:
    pass

func physics_update(_delta: float) -> void:
    pass

func exit() -> void:
    pass
