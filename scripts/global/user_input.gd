extends Node

## Central input abstraction.
##
## Generic signals expose normalized keyboard and mouse input to new systems.
## Legacy signals remain temporarily available for existing Scrollmapper systems.
##
## New interaction logic should subscribe to the generic signals and decide
## ownership inside a feature-specific controller such as VXInteractionController.

const HELD_DELAY: float = 0.1

#region Generic keyboard signals

signal key_pressed(keycode: Key, physical_keycode: Key, text: String)
signal key_released(keycode: Key, physical_keycode: Key, text: String)
signal key_held(keycode: Key, physical_keycode: Key, text: String)

signal escape_pushed
signal space_pushed

#endregion


#region Generic mouse signals

signal mouse_double_clicked(
	button_index: MouseButton,
	position: Vector2
)

signal mouse_button_pressed(
	button_index: MouseButton,
	position: Vector2
)

signal mouse_button_released(
	button_index: MouseButton,
	position: Vector2
)

signal mouse_button_held(
	button_index: MouseButton,
	held_time: float,
	position: Vector2
)

signal mouse_button_held_started(
	button_index: MouseButton,
	position: Vector2
)

signal mouse_button_held_ended(
	button_index: MouseButton,
	held_time: float,
	position: Vector2
)

signal mouse_moved(
	position: Vector2,
	relative: Vector2,
	velocity: Vector2
)

signal mouse_wheel_pulsed(
	direction: int,
	ticks_msec: int,
	position: Vector2
)

## Emitted when active input is forcibly cancelled, such as when the
## application loses focus or another system locks interaction.
signal input_cancelled

#endregion


#region Legacy compatibility signals

## Existing Scrollmapper/VX signals.
## New code should use the generic signals above.

signal clicked
signal click_released
signal shift_clicked(position: Vector2)
signal right_clicked
signal double_clicked
signal ctrl_clicked
signal ctrl_double_clicked

signal mouse_drag_started(position: Vector2)
signal mouse_drag_ended(position: Vector2)
signal mouse_dragged(position: Vector2)

signal mouse_wheel_increased
signal mouse_wheel_decreased

signal space_bar_pressed
signal escape_key_pressed

#endregion


#region Public input state

var mouse_position: Vector2 = Vector2.ZERO
var mouse_relative: Vector2 = Vector2.ZERO
var mouse_velocity: Vector2 = Vector2.ZERO

## Legacy drag state.
##
## This preserves the current Scrollmapper behavior where a left press begins
## a possible drag immediately. VXInteractionController should eventually own
## the distinction between pressing, clicking, and dragging.
var is_dragging: bool = false
var drag_start_position: Vector2 = Vector2.ZERO

#endregion


#region Internal held-button state

## Dictionary format:
## {
##     MouseButton: {
##         "start_msec": int,
##         "held_started": bool
##     }
## }
##
## A dictionary avoids maintaining separate left/right variables and supports
## additional buttons without duplicating the state machine.
var _held_mouse_buttons: Dictionary = {}

#endregion


func _ready() -> void:
	set_process_input(true)
	set_physics_process(true)


func _physics_process(_delta: float) -> void:
	_process_held_mouse_buttons()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		_handle_keyboard_event(event)
		return

	if event is InputEventMouseButton:
		_handle_mouse_button_event(event)
		return

	if event is InputEventMouseMotion:
		_handle_mouse_motion_event(event)


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		force_release_drag()


#region Keyboard handling

func _handle_keyboard_event(event: InputEventKey) -> void:
	var event_text: String = event.as_text()

	if event.pressed:
		if event.echo:
			key_held.emit(
				event.keycode,
				event.physical_keycode,
				event_text
			)
			return

		key_pressed.emit(
			event.keycode,
			event.physical_keycode,
			event_text
		)

		_emit_keyboard_convenience_signals(event)
		return

	# Godot key-release events should not normally be echoes, but the check
	# protects consumers from malformed or manually constructed events.
	if not event.echo:
		key_released.emit(
			event.keycode,
			event.physical_keycode,
			event_text
		)


func _emit_keyboard_convenience_signals(
	event: InputEventKey
) -> void:
	match event.keycode:
		KEY_ESCAPE:
			escape_pushed.emit()
			escape_key_pressed.emit()

		KEY_SPACE:
			space_pushed.emit()
			space_bar_pressed.emit()

#endregion


#region Mouse-button handling

func _handle_mouse_button_event(
	event: InputEventMouseButton
) -> void:
	mouse_position = event.position

	# Mouse wheels are pulses, not buttons that should enter held state.
	if _is_mouse_wheel_button(event.button_index):
		if event.pressed:
			_emit_mouse_wheel_event(event)
		return

	if event.pressed:
		_handle_mouse_button_pressed(event)
	else:
		_handle_mouse_button_released(event)


func _handle_mouse_button_pressed(
	event: InputEventMouseButton
) -> void:
	mouse_button_pressed.emit(
		event.button_index,
		event.position
	)

	_begin_mouse_button_hold(event.button_index)

	if event.double_click:
		_emit_double_click_signals(event)
		return

	_emit_legacy_mouse_press_signals(event)


func _handle_mouse_button_released(
	event: InputEventMouseButton
) -> void:
	mouse_button_released.emit(
		event.button_index,
		event.position
	)

	_end_mouse_button_hold(
		event.button_index,
		event.position
	)

	# Legacy click_released represents the left mouse button only.
	if event.button_index == MOUSE_BUTTON_LEFT:
		click_released.emit()
		_end_legacy_drag(event.position)

func _emit_double_click_signals(
	event: InputEventMouseButton
) -> void:
	mouse_double_clicked.emit(
		event.button_index,
		event.position
	)

	# Preserve existing VX behavior, which recognizes double-click only
	# through the left mouse button.
	if event.button_index != MOUSE_BUTTON_LEFT:
		return

	if event.ctrl_pressed:
		ctrl_double_clicked.emit()
	else:
		double_clicked.emit()


func _emit_legacy_mouse_press_signals(
	event: InputEventMouseButton
) -> void:
	match event.button_index:
		MOUSE_BUTTON_LEFT:
			if event.shift_pressed:
				shift_clicked.emit(event.position)
			elif event.ctrl_pressed:
				ctrl_clicked.emit()
			else:
				clicked.emit()

			_begin_legacy_drag(event.position)

		MOUSE_BUTTON_RIGHT:
			right_clicked.emit()


func _emit_mouse_wheel_event(
	event: InputEventMouseButton
) -> void:
	var direction: int

	match event.button_index:
		MOUSE_BUTTON_WHEEL_UP:
			direction = 1
			mouse_wheel_increased.emit()

		MOUSE_BUTTON_WHEEL_DOWN:
			direction = -1
			mouse_wheel_decreased.emit()

		_:
			return

	mouse_wheel_pulsed.emit(
		direction,
		Time.get_ticks_msec(),
		event.position
	)


func _is_mouse_wheel_button(
	button_index: MouseButton
) -> bool:
	return (
		button_index == MOUSE_BUTTON_WHEEL_UP
		or button_index == MOUSE_BUTTON_WHEEL_DOWN
		or button_index == MOUSE_BUTTON_WHEEL_LEFT
		or button_index == MOUSE_BUTTON_WHEEL_RIGHT
	)

#endregion


#region Held-button handling

func _begin_mouse_button_hold(
	button_index: MouseButton
) -> void:
	_held_mouse_buttons[button_index] = {
		"start_msec": Time.get_ticks_msec(),
		"held_started": false
	}


func _end_mouse_button_hold(
	button_index: MouseButton,
	position: Vector2
) -> void:
	if not _held_mouse_buttons.has(button_index):
		return

	var held_data: Dictionary = _held_mouse_buttons[button_index]
	var held_time: float = _get_held_time(held_data)

	if held_data["held_started"]:
		mouse_button_held_ended.emit(
			button_index,
			held_time,
			position
		)

	_held_mouse_buttons.erase(button_index)


func _process_held_mouse_buttons() -> void:
	if _held_mouse_buttons.is_empty():
		return

	# Duplicate the keys so signal callbacks may safely cause cancellation
	# without mutating the collection currently being iterated.
	var held_buttons: Array = _held_mouse_buttons.keys()

	for button_variant: Variant in held_buttons:
		var button_index: MouseButton = button_variant

		if not _held_mouse_buttons.has(button_index):
			continue

		var held_data: Dictionary = (
			_held_mouse_buttons[button_index]
		)

		var held_time: float = _get_held_time(held_data)

		if held_time < HELD_DELAY:
			continue

		if not held_data["held_started"]:
			held_data["held_started"] = true
			_held_mouse_buttons[button_index] = held_data

			mouse_button_held_started.emit(
				button_index,
				mouse_position
			)

		mouse_button_held.emit(
			button_index,
			held_time,
			mouse_position
		)


func _get_held_time(held_data: Dictionary) -> float:
	var start_msec: int = held_data["start_msec"]
	var elapsed_msec: int = (
		Time.get_ticks_msec() - start_msec
	)

	# The float divisor is important. Integer division would destroy the
	# quarter-second precision required by HELD_DELAY.
	return elapsed_msec / 1000.0

#endregion


#region Mouse-motion handling

func _handle_mouse_motion_event(
	event: InputEventMouseMotion
) -> void:
	mouse_position = event.position
	mouse_relative = event.relative
	mouse_velocity = event.velocity

	mouse_moved.emit(
		event.position,
		event.relative,
		event.velocity
	)

	if is_dragging:
		mouse_dragged.emit(event.position)

#endregion


#region Legacy drag handling

func _begin_legacy_drag(position: Vector2) -> void:
	is_dragging = true
	drag_start_position = position
	mouse_drag_started.emit(position)


func _end_legacy_drag(position: Vector2) -> void:
	if not is_dragging:
		return

	is_dragging = false
	drag_start_position = Vector2.ZERO
	mouse_drag_ended.emit(position)

#endregion


#region State queries

func is_shift_pressed() -> bool:
	return Input.is_key_pressed(KEY_SHIFT)

func is_ctrl_pressed() -> bool:
	return Input.is_key_pressed(KEY_CTRL)

func is_mouse_button_held(
	button_index: MouseButton
) -> bool:
	return _held_mouse_buttons.has(button_index)


func get_mouse_button_held_time(
	button_index: MouseButton
) -> float:
	if not _held_mouse_buttons.has(button_index):
		return 0.0

	return _get_held_time(
		_held_mouse_buttons[button_index]
	)


func get_mouse_position() -> Vector2:
	return mouse_position


func get_drag_start_position() -> Vector2:
	return drag_start_position

#endregion


#region Cancellation and safety

## Cancels all active input and emits the appropriate cleanup signals.
##
## Use this when:
## - the application loses focus;
## - a modal dialogue opens;
## - the active graph changes;
## - an interaction owner is deleted;
## - input must be forcibly released.
func cancel_active_input() -> void:
	var had_active_input: bool = (
		is_dragging
		or not _held_mouse_buttons.is_empty()
	)

	if not had_active_input:
		return

	var held_buttons: Array = _held_mouse_buttons.keys()

	for button_variant: Variant in held_buttons:
		var button_index: MouseButton = button_variant

		if not _held_mouse_buttons.has(button_index):
			continue

		var held_data: Dictionary = (
			_held_mouse_buttons[button_index]
		)

		if held_data["held_started"]:
			mouse_button_held_ended.emit(
				button_index,
				_get_held_time(held_data),
				mouse_position
			)

	_held_mouse_buttons.clear()

	if is_dragging:
		is_dragging = false
		drag_start_position = Vector2.ZERO
		mouse_drag_ended.emit(mouse_position)

	input_cancelled.emit()


## Legacy compatibility wrapper.
##
## Unlike the old implementation, this performs full cleanup and emits
## drag-ended so subscribers cannot remain stuck in an active state.
func force_release_drag() -> void:
	cancel_active_input()

#endregion
