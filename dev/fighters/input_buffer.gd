class_name InputBuffer extends Node

# Exports

# 150ms = 9 frames
static var buffer_window: int = 150

static var joy_deadzone: float = 0.2


# Static Members

static var _keyboard_timestamps: Dictionary
static var _joypad_timestamps: Dictionary
static var _joymotion_timestamps: Dictionary

static func is_action_press_buffered(action: String) -> bool:
	for event in InputMap.action_get_events(action):

		match event.get_class():
			"InputEventKey":
				var event_key: InputEventKey = event
				var scan_code = event_key.keycode
				if _keyboard_timestamps.has(scan_code):
					if Time.get_ticks_msec() - _keyboard_timestamps[scan_code] <= buffer_window:
						invalidate_action(action)
						return true

			"InputEventJoypadButton":
				var event_button: InputEventJoypadButton = event
				var button_index: JoyButton = event_button.button_index

				if _joypad_timestamps.has(button_index):
					if Time.get_ticks_msec() - _joypad_timestamps[button_index] <= buffer_window:
						invalidate_action(action)
						return true

			"InputEventJoypadMotion":
				var event_motion: InputEventJoypadMotion = event
				if absf(event_motion.axis_value) < joy_deadzone:
					return false

				var axis_code: String = str(event_motion.axis) + "_" + str(sign(event_motion.axis_value))
				if _joymotion_timestamps.has(axis_code):
					var delta: float = Time.get_ticks_msec() - _joymotion_timestamps[axis_code]
					if delta <= buffer_window:
						invalidate_action(action)
						return true

	return false

static func invalidate_action(action: String) -> void:
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			var event_key: InputEventKey = event
			var scan_code = event_key.keycode

			if _keyboard_timestamps.has(scan_code):
				_keyboard_timestamps[scan_code] = 0


# Lifecycle Methods

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_keyboard_timestamps = {}
	_joypad_timestamps = {}
	_joymotion_timestamps = {}

func _input(event: InputEvent) -> void:
	match event.get_class():

		"InputEventKey":
			var event_key: InputEventKey = event
			if (!event_key.is_pressed() or event_key.is_echo()):
				return
			_keyboard_timestamps[event_key.keycode] = Time.get_ticks_msec()

		"InputEventJoypadButton":
			var event_joypad_button: InputEventJoypadButton = event
			if (!event_joypad_button.is_pressed() or event_joypad_button.is_echo()):
				return

			var button_index: JoyButton = event_joypad_button.button_index
			_joypad_timestamps[button_index] = Time.get_ticks_msec()

		"InputEventJoypadMotion":
			var event_joypad_motion: InputEventJoypadMotion = event

			if (absf(event_joypad_motion.axis_value < joy_deadzone)):
				return

			var axis_code: String = str(event_joypad_motion.axis) + "_" + str(sign(event_joypad_motion.axis_value))
			_joymotion_timestamps[axis_code] = Time.get_ticks_msec()
