extends Line2D

## The VXConnection class is the connection between two VXNodes.
## Connections connect to sockets, but the connecting nodes can also
## be referenced here.
## A great melody I was listening to while creating this project:
## https://www.youtube.com/watch?v=3gL9kWD9XRo&t=1457s

class_name VXConnection

#region model vars
@export_group("Model Variables")

## The ID of the connection.
@export var id:int = -1

## This is optional user text
@export var text: String = ""

## The starting node of the connection.
@export var start_node: VXNode = null

## The ending node of the connection.
@export var end_node: VXNode = null

## The starting socket of the connection.
@export var start_socket: VXSocket = null

## The ending socket of the connection.
@export var end_socket: VXSocket = null

## Indicates if the connection is parallel. Assumed linear if not.
@export var is_parallel: bool = false

@export var color_linear:Color 
@export var color_parallel:Color 

#endregion

## Indicates if the connection is being edited.
var is_connection_being_edited: bool = false:
	set(new_value):
		if new_value == true:
			set_process(true)
			connection_drag_active = true
		else:
			set_process(false)
			connection_drag_active = false
		is_connection_being_edited = new_value


static var connection_drag_active:bool = false

## Points per meter for the connection.
@export var points_per_meter: int = 59

## Increase this value to make the curve more extreme
@export var control_point_offset: float = 50

signal connection_finalized(start_node:VXNode, end_node:VXNode)

## Initialization function
func initiate(start_socket: VXSocket, end_socket: VXSocket = null):
	is_connection_being_edited = true
	self.start_socket = start_socket
	self.end_socket = end_socket
	get_starting_socket().socket_edit_ended.connect(_on_editing_ended)
	establish_starting_connection_points()
	VXInput.instance.force_dragging_connection() 

## Function to get the connection as a dictionary.
## This is used to save the connection to the database.
func get_as_dictionary() -> Dictionary:
	var dict: Dictionary = {}
	dict["id"] = id
	dict["text"] = text
	dict["start_node"] = start_node.get_node_id()
	dict["end_node"] = end_node.get_node_id()
	dict["is_parallel"] = is_parallel
	dict["start_socket_index"] = start_socket.get_socket_index()
	dict["end_socket_index"] = end_socket.get_socket_index()
	dict["start_node_side"] = start_socket.get_socket_side()
	dict["end_node_side"] = end_socket.get_socket_side()
	return dict

## Function to get the "other node". Used when nodes are discovering eachother's connections.
## This function is used to get the node that is not the one supplied.
## For example, if the start_node is supplied, the end_node is returned.
func get_other_node(node: VXNode) -> VXNode:
	if start_node == node:
		return end_node
	elif end_node == node:
		return start_node
	return null

## Sets the connection ID based on the scripture references of the start and end nodes.
## This function generates a unique numerical hash from the string representation of the 
## scripture references in the format "<start_scripture> <end_scripture>".
## It should be called after the connection is established (i.e., after the initiate method).
func set_connection_id():
	if start_node == null or end_node == null:
		return
	id = ScriptureService.get_connection_id(
		start_node.book, 
		start_node.chapter, 
		start_node.verse, 
		end_node.book, 
		end_node.chapter, 
		end_node.verse
	)

## Gets the connection id
func get_connection_id() -> int:
	return id

## Process function
func _process(delta: float) -> void:
	update_connection_points_mouse_drag()

## Connection finalized, add the connection to the VXGraph vx_connections dictionary.
func _on_connection_finalized(start_node:VXNode, end_node:VXNode) -> void:
	if id == -1: # If the connection ID is not set, set it.
		set_connection_id()
		VXGraph.get_instance().add_vx_connection(self)

## The main function to connect sockets.
## This function fires after mouse-up on editing.
func do_socket_connections() -> void:
	end_socket = get_target_socket()
	is_connection_being_edited = false
	if not is_connection_route_valid():
		delete_connection()	
		return
	start_socket.connection = self
	end_socket.connection = self
	connect_signals()
	get_starting_socket().emit_new_connection_created(get_starting_socket(), get_ending_socket())
	get_ending_socket().emit_new_connection_created(get_starting_socket(), get_ending_socket())
	finalize_connection_points()

## Delete the connection
func delete_connection():
	# First, remove the connection from the VXGraph vx_connections dictionary...
	VXGraph.get_instance().remove_vx_connection(self)
	# Now delete the connection...
	if start_socket != null:
		start_socket.delete()
	if end_socket != null:
		end_socket.delete()
	start_socket = null
	end_socket = null
	start_node = null
	end_node = null
	queue_free()

## Connect the signal handlers
func connect_signals():
	connection_finalized.connect(_on_connection_finalized)	
	if not get_starting_socket().node_moved.is_connected(_on_socket_moved):
		get_starting_socket().node_moved.connect(_on_socket_moved)
	if not get_ending_socket().node_moved.is_connected(_on_socket_moved):
		get_ending_socket().node_moved.connect(_on_socket_moved)
	if not get_starting_socket().socket_updated.is_connected(_on_socket_updated):
		get_starting_socket().socket_updated.connect(_on_socket_updated)
	if not get_ending_socket().socket_updated.is_connected(_on_socket_updated):
		get_ending_socket().socket_updated.connect(_on_socket_updated)
	if not tree_exiting.is_connected(retire_connection):
		tree_exiting.connect(retire_connection)

## Handle editing ended
func _on_editing_ended() -> void:
	do_socket_connections()

## Various checks to determine if the connection is valid.
func is_connection_route_valid() -> bool:
	# CASE: Node connected to self. Not going to work.
	if get_starting_socket() == get_ending_socket():
		VXGraph.get_instance().print_feedback_note("Rejection: Node connected to self")
		return false
	# CASE: No target socket. Not going to work.
	if get_ending_socket() == null:
		VXGraph.get_instance().print_feedback_note("Rejection: No target socket")
		return false
	# CASE: Socket combination is invalid; ie, input to input, output to output, etc.
	if not is_connection_valid(get_starting_socket(), get_ending_socket()):
		return false
	# CASE: Connection already exists between these two scriptures.
	if VXGraph.get_instance().has_connection_id(
		ScriptureService.get_connection_id(
			get_starting_socket().get_connected_node().book, 
			get_starting_socket().get_connected_node().chapter, 
			get_starting_socket().get_connected_node().verse, 
			get_ending_socket().get_connected_node().book, 
			get_ending_socket().get_connected_node().chapter, 
			get_ending_socket().get_connected_node().verse
		)
	): 
		VXGraph.get_instance().print_feedback_note("Rejection: Connection between these verses already exists")
		return false
	# CASE: Valid connection. Connect the sockets.
	if get_ending_socket() != null and get_starting_socket() != null:
		return true
	# CASE: Still unknown. Default false.
	VXGraph.get_instance().print_feedback_note("Rejection: Unknown case")
	return false

## Validate connection based on socket types and directions
func is_connection_valid(start_sock: VXSocket, end_sock: VXSocket) -> bool:
	# Inputs cannot connect to inputs
	if start_sock.socket_type == Types.SocketType.INPUT and end_sock.socket_type == Types.SocketType.INPUT:
		VXGraph.get_instance().print_feedback_note("Rejection: Inputs cannot connect to inputs")
		return false
	# Outputs cannot connect to outputs
	if start_sock.socket_type == Types.SocketType.OUTPUT and end_sock.socket_type == Types.SocketType.OUTPUT:
		VXGraph.get_instance().print_feedback_note("Rejection: Outputs cannot connect to outputs")
		return false
	# Parallels cannot connect to linears
	if start_sock.socket_direction == Types.SocketDirectionType.PARALLEL and end_sock.socket_direction == Types.SocketDirectionType.LINEAR:
		VXGraph.get_instance().print_feedback_note("Rejection: Parallels cannot connect to linears")
		return false
	# Linears cannot connect to parallels
	if start_sock.socket_direction == Types.SocketDirectionType.LINEAR and end_sock.socket_direction == Types.SocketDirectionType.PARALLEL:
		VXGraph.get_instance().print_feedback_note("Rejection: Linears cannot connect to parallels")
		return false
	# Linears can connect to linears
	if start_sock.socket_direction == Types.SocketDirectionType.LINEAR and end_sock.socket_direction == Types.SocketDirectionType.LINEAR:
		return true
	# Parallels can connect to parallels
	if start_sock.socket_direction == Types.SocketDirectionType.PARALLEL and end_sock.socket_direction == Types.SocketDirectionType.PARALLEL:
		return true
	# Inputs can connect to outputs
	if start_sock.socket_type == Types.SocketType.INPUT and end_sock.socket_type == Types.SocketType.OUTPUT:
		return true
	# Outputs can connect to inputs
	if start_sock.socket_type == Types.SocketType.OUTPUT and end_sock.socket_type == Types.SocketType.INPUT:
		return true
	# Default case: invalid connection
	VXGraph.get_instance().print_feedback_note("Rejection: Default case - invalid connection")
	return false

## Retire connection
func retire_connection():
	if start_socket != null:
		start_socket.queue_free()
	if end_socket != null:
		end_socket.queue_free()
	if start_node != null:
		start_node.update_sockets()
	if end_node != null:
		end_node.update_sockets()

## Handle socket moved
func _on_socket_moved(pos: Vector2) -> void:
	finalize_connection_points()

## Handle socket updated
func _on_socket_updated() -> void:
	finalize_connection_points()

## Get the starting socket
func get_starting_socket() -> VXSocket:
	return start_socket

## Get the ending socket
func get_ending_socket() -> VXSocket:
	return end_socket

## Get the target socket
func get_target_socket() -> VXSocket:
	if VXGraph.current_focused_socket != null:
		if VXGraph.current_focused_socket == self:
			return null
		return VXGraph.current_focused_socket
	return null

## Establish initial connection points.
func establish_starting_connection_points() -> void:
	add_point(get_socket_point(get_starting_socket()))
	add_point(get_connection_mouse_position())

## Finalize connection points
func finalize_connection_points():
	if get_tree() == null:
		return
	await get_tree().process_frame
	set_start_and_end_points_connected()
	start_node = get_starting_socket().get_connected_node()
	end_node = get_ending_socket().get_connected_node()
	
	match get_starting_socket().socket_direction:
		Types.SocketDirectionType.LINEAR:
			is_parallel = false
		Types.SocketDirectionType.PARALLEL:
			is_parallel = true

	create_node_curve_by_connection()
	connection_finalized.emit(start_node, end_node)
	move_to_front()

## Update connection points during mouse drag
func update_connection_points_mouse_drag():
	create_node_curve_by_mouse()

## Creates the start and end points based on the finalized connection
func set_start_and_end_points_connected() -> void:
	set_point_position(
		get_start_point_index(),
		get_socket_point(get_starting_socket())
	)

	set_point_position(
		get_end_point_index(),
		get_socket_point(get_ending_socket())
	)
	

## Creates the start and end points based on the mouse.
## The starting point remains attached to the starting socket.
func set_start_and_end_points_mouse_drag() -> void:
	set_point_position(
		get_start_point_index(),
		get_socket_point(get_starting_socket())
	)

	set_point_position(
		get_end_point_index(),
		get_connection_mouse_position()
	)

func start_and_end_point_exists() -> bool:
	return points.size() >= 2

## Returns the index of the starting point.
func get_start_point_index() -> int:
	return 0

## Returns the index of the ending point.
func get_end_point_index() -> int:	
	return points.size() - 1

## Returns the position of the first point.
func get_start_point() -> Vector2:
	return points[0]

## Returns the position of the last point.
func get_end_point() -> Vector2:
	return points[points.size() - 1]

## Gets the starting control point. Control point offset is controlled by 
## exported control_point_offset variable above. 
func get_start_control_point() -> Vector2:
	var start_direction: Types.SocketDirectionType = get_starting_socket().socket_direction
	var start_point = get_start_point()
	var control_point = start_point

	match start_direction:
		Types.SocketDirectionType.LINEAR:
			if get_starting_socket().socket_type == Types.SocketType.OUTPUT:
				control_point.y += control_point_offset
			else:
				control_point.y -= control_point_offset
		Types.SocketDirectionType.PARALLEL:
			if get_starting_socket().socket_type == Types.SocketType.OUTPUT:
				control_point.x += control_point_offset
			else:
				control_point.x -= control_point_offset

	return control_point

## Gets the ending control point. Control point offset is controlled by 
## exported control_point_offset variable above. 
func get_end_control_point() -> Vector2:
	var end_direction: Types.SocketDirectionType = get_ending_socket().socket_direction
	var end_point = get_end_point()
	var control_point = end_point

	match end_direction:
		Types.SocketDirectionType.LINEAR:
			if get_ending_socket().socket_type == Types.SocketType.INPUT:
				control_point.y -= control_point_offset
			else:
				control_point.y += control_point_offset
		Types.SocketDirectionType.PARALLEL:
			if get_ending_socket().socket_type == Types.SocketType.INPUT:
				control_point.x -= control_point_offset
			else:
				control_point.x += control_point_offset

	return control_point

## Converts a socket's global connection point into this Line2D's local space.
func get_socket_point(socket: VXSocket) -> Vector2:
	return to_local(socket.get_connection_point())


## Gets the mouse position in this Line2D's local space.
func get_connection_mouse_position() -> Vector2:
	return get_local_mouse_position()

## Cubic Bezier curve calculation
func cubic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var q2 = p2.lerp(p3, t)

	var r0 = q0.lerp(q1, t)
	var r1 = q1.lerp(q2, t)

	var s = r0.lerp(r1, t)
	return s

## Create node curve based on mouse position
func create_node_curve_by_mouse():
	set_start_and_end_points_mouse_drag()
	create_node_curve()

## Create node curve based on connection points
func create_node_curve_by_connection():
	set_start_and_end_points_connected()
	create_node_curve()

## Create node curve
func create_node_curve() -> void:
	var start_point := get_start_point()
	var end_point := get_end_point()

	var start_control := get_start_control_point()

	# The default state of the end point is the mouse position.
	var end_control := get_connection_mouse_position()

	# If we are not editing, and the end control point exists, then it is
	# a finalized connection.
	if not is_connection_being_edited:
		end_control = get_end_control_point()

	clear_points()

	for i in range(points_per_meter + 1):
		var t := float(i) / float(points_per_meter)
		var curve_point = cubic_bezier(
			start_point,
			start_control,
			end_control,
			end_point,
			t
		)
		add_point(curve_point)

	if is_parallel:
		default_color = color_parallel
	else:
		default_color = color_linear
	
## Recalculates the connection curve.
func recalculate_connection_curve():
	create_node_curve()
