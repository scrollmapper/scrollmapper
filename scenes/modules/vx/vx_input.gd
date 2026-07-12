## Centralizes mouse input information used by the VX graph system.
##
## VXInput maintains a single per-frame snapshot of the physics objects beneath
## the mouse. Other VX systems can inspect this snapshot without performing
## duplicate physics queries or maintaining conflicting hover states.
extends Control
class_name VXInput

#region Signals

## Fired when a user double clicks over the canvas. 
signal cursor_move_requested(position:Vector2)

## Fired when a user double clicks over a node. 
signal open_node_control_window_requested(vx_node:VXNode)
 
## Requests that a VXNode become the primary selected node.
signal node_selection_requested(vx_node: VXNode)

## Requests that a VXNode be added to or removed from the multi-selection.
signal node_multi_selection_requested(vx_node: VXNode)

## Requests that a VXNode be deleted from the graph.
signal node_deletion_requested(vx_node: VXNode)

## Requests that the nodes connected to a VXNode be automatically arranged.
signal connected_nodes_arrangement_requested(vx_node: VXNode)

## Requests that the graph canvas zoom be adjusted by the given amount.
signal canvas_zoom_requested(amount: float)

## Requests that the current node selection be cleared.
signal selection_clear_requested

#endregion 

#region Constants

## Maximum number of physics objects returned by the mouse point query.
const MAX_MOUSE_QUERY_RESULTS: int = 32

## Includes every physics collision layer in the mouse point query.
const MOUSE_QUERY_COLLISION_MASK: int = 0xFFFFFFFF

enum VXInteraction {
	NONE,
	PANNING_CANVAS,
	DRAGGING_NODE,
	DRAGGING_CONNECTION,
}

#endregion

#region Exported Variables

## The Control defining the usable rectangular area of the graph canvas.
##
## This Control may also act as a layout spacer. Its global rectangle is used to
## determine whether the mouse is inside the graph's work area.
@export var canvas_area: MarginContainer

#endregion



#region Main Variables

## The active VXInput instance.
static var instance: VXInput = null


## Physics-query results beneath the mouse during the current frame.
##
## Each entry is a dictionary returned by `intersect_point()` and contains a
## collider reference. Results are sorted from highest to lowest effective
## CanvasItem z-index.
var objects_under_mouse: Array[Dictionary] = []

## The current action in process 
var current_action:VXInteraction = VXInteraction.NONE

#endregion


#region Hovered Data Variables

## The current VXNode being hovered. Null if none. Updated per frame.
var hovered_vx_node:VXNode = null

## The current VXSocket being hovered. Null if none. Updated per frame.
var hovered_vx_socket:VXSocket = null

#endregion 

#region Lifecycle

func _ready() -> void:
	if instance != null and instance != self:
		push_error("Multiple VXInput instances detected.")
		queue_free()
		return

	instance = self
	
	UserInput.mouse_button_held_started.connect(_on_mouse_button_held_started)
	UserInput.mouse_button_held_ended.connect(_on_mouse_button_held_ended)
	UserInput.mouse_double_clicked.connect(_on_mouse_double_clicked)
	UserInput.mouse_button_pressed.connect(_on_mouse_button_pressed)
	UserInput.mouse_wheel_pulsed.connect(_on_mouse_wheel_pulsed)
	UserInput.escape_pushed.connect(_on_escape_pushed)
	
## Refreshes the collection of physics objects beneath the mouse once per frame.
func _process(_delta: float) -> void:
	update_objects_under_mouse()
	update_hovered_data()

func _exit_tree() -> void:
	if instance == self:
		instance = null

#endregion

#region Helpers

## Forces dragging connection mode (to beat input lag or delay)
func force_dragging_connection() -> void:
	current_action = VXInteraction.DRAGGING_CONNECTION

## Forces dragging node mode (to beat input lag or delay)
func force_dragging_node() -> void:
	current_action = VXInteraction.DRAGGING_NODE

## Forces panning canvase mode (to beat input lag or delay)
func force_panning_canvas() -> void:
	current_action = VXInteraction.PANNING_CANVAS

#endregion

#region Signal Processing

func _on_mouse_button_held_started(button_index: MouseButton, _position: Vector2) -> void:
	if button_index == MouseButton.MOUSE_BUTTON_LEFT:
		if current_action != VXInteraction.NONE:
			return
		if is_mouse_over_node():
			current_action = VXInteraction.DRAGGING_NODE
		if is_mouse_over_socket():
			current_action = VXInteraction.DRAGGING_CONNECTION
		if is_mouse_over_canvas():
			current_action = VXInteraction.PANNING_CANVAS

func _on_mouse_button_held_ended(button_index: MouseButton, _held_time: float, _position: Vector2) -> void:
	if button_index == MouseButton.MOUSE_BUTTON_LEFT:
		if current_action == VXInteraction.DRAGGING_NODE:
			current_action = VXInteraction.NONE
		if current_action == VXInteraction.DRAGGING_CONNECTION:
			current_action = VXInteraction.NONE
		if current_action == VXInteraction.PANNING_CANVAS:
			current_action = VXInteraction.NONE
	
func _on_mouse_double_clicked(button_index: MouseButton, position: Vector2) -> void:
	if button_index == MouseButton.MOUSE_BUTTON_LEFT:
		if is_mouse_over_canvas():
			cursor_move_requested.emit(position)
			selection_clear_requested.emit()
		if is_mouse_over_node() and hovered_vx_node != null:
			if UserInput.is_ctrl_pressed():
				connected_nodes_arrangement_requested.emit(hovered_vx_node)
			else:
				open_node_control_window_requested.emit(hovered_vx_node)
		

func _on_mouse_button_pressed(button_index: MouseButton, _position: Vector2) -> void:
	
	
	if button_index == MouseButton.MOUSE_BUTTON_LEFT:
		if is_mouse_over_node() and hovered_vx_node != null:
			if UserInput.is_shift_pressed():
				node_multi_selection_requested.emit(hovered_vx_node)
			else:			
				node_selection_requested.emit(hovered_vx_node)
		
		if is_mouse_over_canvas() and is_mouse_over_work_area():
			# A hack to overcome a bug where if the user starts panning from a point
			# near a node, it doesn't register in time and starts dragging the node
			# shortly after intended panning starts.
			force_panning_canvas()
		
	if button_index == MouseButton.MOUSE_BUTTON_RIGHT:
		if is_mouse_over_node() and hovered_vx_node != null:
			node_deletion_requested.emit(hovered_vx_node)

## Relays mouse-wheel input as a camera zoom request when the mouse is inside
## the graph work area.
func _on_mouse_wheel_pulsed(direction: int, _ticks_msec: int, _position: Vector2) -> void:
	if not is_mouse_over_work_area():
		return

	if direction > 0:
		canvas_zoom_requested.emit(1.1)
	elif direction < 0:
		canvas_zoom_requested.emit(0.9)

func _on_escape_pushed() -> void:
	selection_clear_requested.emit()

#endregion 

#region Mouse Query

## Refreshes and returns the physics objects beneath the mouse cursor.
##
## The mouse position begins in viewport coordinates and is converted into the
## canvas coordinates used by the active Camera2D. This keeps the query accurate
## while the graph camera moves or zooms.
##
## Only Area2D objects are included. PhysicsBody2D objects are ignored.
##
## Results are stored in `objects_under_mouse` and sorted from highest to lowest
## effective CanvasItem z-index. Therefore, index 0 represents the visually
## highest detected object when at least one result exists.
func update_objects_under_mouse() -> Array[Dictionary]:
	var viewport := get_viewport()

	if viewport == null or viewport.world_2d == null:
		objects_under_mouse.clear()
		return objects_under_mouse

	var mouse_viewport_position := viewport.get_mouse_position()

	var mouse_world_position := (
		viewport.get_canvas_transform().affine_inverse()
		* mouse_viewport_position
	)

	var query := PhysicsPointQueryParameters2D.new()
	query.position = mouse_world_position
	query.collision_mask = MOUSE_QUERY_COLLISION_MASK
	query.collide_with_areas = true
	query.collide_with_bodies = false

	var space_state := viewport.world_2d.direct_space_state

	objects_under_mouse = space_state.intersect_point(
		query,
		MAX_MOUSE_QUERY_RESULTS
	)

	objects_under_mouse.sort_custom(_sort_mouse_results_by_depth)

	return objects_under_mouse

## Updates data concerning focused objects in the canvas area. 
func update_hovered_data() -> void:
	hovered_vx_socket = null
	hovered_vx_node = null
	for result: Dictionary in objects_under_mouse:
		var collider := _get_collider_from_result(result)

		if collider == null:
			continue

		if collider.get_parent() is VXSocket and hovered_vx_socket == null:
			hovered_vx_socket = collider.get_parent()
			
		if collider.get_parent() is VXNode and hovered_vx_node == null:
			hovered_vx_node = collider.get_parent()

#endregion


#region Mouse State

## Returns true when the current mouse-query snapshot contains any Area2D.
##
## This reads `objects_under_mouse` and does not perform another physics query.
func is_mouse_over_area2d() -> bool:
	return not objects_under_mouse.is_empty()


## Returns true when the mouse is over an Area2D belonging directly to a VXNode.
##
## This expects the detected Area2D to be a direct child of the VXNode.
func is_mouse_over_node() -> bool:
	for result: Dictionary in objects_under_mouse:
		var collider := _get_collider_from_result(result)

		if collider == null:
			continue

		if collider.get_parent() is VXNode:
			return true

	return false

## Check to see if the node being tested is the same being hovered. 
func is_mouse_over_this_node(vx_node:VXNode) -> bool:
	return hovered_vx_node == vx_node

## Returns true when the mouse is over an Area2D belonging directly to a VXSocket.
##
## This expects the detected Area2D to be a direct child of the VXSocket.
func is_mouse_over_socket() -> bool:
	for result: Dictionary in objects_under_mouse:
		var collider := _get_collider_from_result(result)

		if collider == null:
			continue

		if collider.get_parent() is VXSocket:
			return true

	return false

## Check to see if the socket being tested is the same being hovered. 
func is_mouse_over_this_socket(vx_socket:VXSocket) -> bool:
	return hovered_vx_socket == vx_socket


## Returns true when the mouse is over an empty portion of the graph canvas.
##
## The mouse must be inside `canvas_area`, and the current physics query must not
## contain any Area2D. Nodes, sockets, and all other detected Area2D objects
## therefore prevent the location from being considered empty canvas.
func is_mouse_over_canvas() -> bool:
	return (
		is_mouse_over_work_area()
		and not is_mouse_over_area2d()
	)


## Returns true when the mouse is inside the graph work area and the point is
## not covered by unrelated UI.
func is_mouse_over_work_area() -> bool:
	if not is_instance_valid(canvas_area):
		return false

	var viewport := get_viewport()
	var mouse_position := viewport.get_mouse_position()

	if not canvas_area.get_global_rect().has_point(mouse_position):
		return false

	var hovered_control := viewport.gui_get_hovered_control()

	if hovered_control == null:
		return true

	return (
		hovered_control == canvas_area
		or canvas_area.is_ancestor_of(hovered_control)
	)

#endregion


#region Private Helpers

## Safely extracts an Area2D collider from an intersect-point result.
##
## Returns null when the result has no collider, the collider was freed, or the
## detected collision object is not an Area2D.
func _get_collider_from_result(result: Dictionary) -> Area2D:
	var collider := result.get("collider") as Area2D

	if not is_instance_valid(collider):
		return null

	return collider


## Sorts mouse-query results from highest to lowest effective visual depth.
##
## When a collider is the child of another CanvasItem, its parent is treated as
## the interactive visual object. This matches the current VXNode and VXSocket
## scene structure, where an Area2D supplies collision for its parent object.
func _sort_mouse_results_by_depth(
	result_a: Dictionary,
	result_b: Dictionary
) -> bool:
	var collider_a := _get_collider_from_result(result_a)
	var collider_b := _get_collider_from_result(result_b)

	if collider_a == null:
		return false

	if collider_b == null:
		return true

	var item_a := _get_interactive_canvas_item(collider_a)
	var item_b := _get_interactive_canvas_item(collider_b)

	return (
		_get_effective_z_index(item_a)
		> _get_effective_z_index(item_b)
	)


## Returns the CanvasItem whose visual depth represents the detected collider.
##
## The collider's parent is preferred because VX collision areas are children of
## the visible VXNode or VXSocket. The collider itself is used as a fallback.
func _get_interactive_canvas_item(collider: Area2D) -> CanvasItem:
	var parent := collider.get_parent() as CanvasItem

	if parent != null:
		return parent

	return collider


## Calculates a CanvasItem's effective z-index, including relative parent depth.
##
## Parent z-index values are accumulated while `z_as_relative` remains enabled.
## If a CanvasItem disables relative z ordering, traversal stops at that item.
func _get_effective_z_index(item: CanvasItem) -> int:
	if item == null:
		return -4096

	var effective_z_index := item.z_index
	var current_item := item

	while current_item.z_as_relative:
		var parent_item := current_item.get_parent() as CanvasItem

		if parent_item == null:
			break

		effective_z_index += parent_item.z_index
		current_item = parent_item

	return effective_z_index

#endregion
