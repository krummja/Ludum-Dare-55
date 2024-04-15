class_name BaseController extends Node

var facing: Constants.Direction

var motion = {
    Constants.Motions.IDLE: false,
    Constants.Motions.MOVE: false,
    Constants.Motions.AIR: false,
    Constants.Motions.CROUCH: false,
}

var action = Constants.Actions.IDLE

var left_move: float = 0.0
var right_move: float = 0.0
