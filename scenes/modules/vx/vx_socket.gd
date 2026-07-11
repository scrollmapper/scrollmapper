extends Node2D
class_name VXSocket

# Variables

@export var size:Vector2 = Vector2(20,20)
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@export var center: Node2D 

## The type of the socket, input or output. vx_socket
var socket_type: Types.SocketType
## The direction of the socket, parallel or linear. vx_socket
var socket_direction: Types.SocketDirectionType
## The connection attached to the socket. Null if no connection. vx_connection
var connection: VXConnection = null
## The node that the socket is connected to. vx_node
var connected_node: VXNode = null
## This determines if the mouse is over the socket for editing purposes.
var is_mouse_over_socket = false
var is_socket_being_edited: bool = false:
	set(new_value):
		if new_value == true:
			socket_edit_started.emit()
		else:
			socket_edit_ended.emit()
		is_socket_being_edited = new_value


# Signals
signal new_connection_created(start_socket: VXSocket, end_socket: VXSocket)
signal node_moved(position: Vector2)
signal socket_updated
signal socket_edit_started
signal socket_edit_ended


# Functions
func _ready():
	UserInput.mouse_drag_started.connect(_on_editing_started)
	UserInput.mouse_drag_ended.connect(_on_editing_ended)
	area_2d.mouse_entered.connect(_on_mouse_entered)
	area_2d.mouse_exited.connect(_on_mouse_exited)
	new_connection_created.connect(notify_node_of_new_connection)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		pass # perhaps future use
	elif event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if UserInput.is_dragging:
				set_currently_editing(true)

## Get the index of the socket in the connected node.
## This is used to determine the position of the connection, which is used for 
## reconstruction when fetched from database. (It can be used for other purposes as well.)
func get_socket_index() -> int:
	var socket_array:Array = []
	if socket_type == Types.SocketType.INPUT && socket_direction == Types.SocketDirectionType.PARALLEL:
		socket_array = connected_node.sockets_left
	elif socket_type == Types.SocketType.INPUT && socket_direction == Types.SocketDirectionType.LINEAR:
		socket_array = connected_node.sockets_top
	elif socket_type == Types.SocketType.OUTPUT && socket_direction == Types.SocketDirectionType.PARALLEL:
		socket_array = connected_node.sockets_right
	elif socket_type == Types.SocketType.OUTPUT && socket_direction == Types.SocketDirectionType.LINEAR:
		socket_array = connected_node.sockets_bottom

	for socket in socket_array:
		if socket == self:
			return socket_array.find(socket)
	return -1
	
## Gets the side of the node that the socket is connected to.
## 0 = Top
## 1 = Bottom
## 2 = Left
## 3 = Right
func get_socket_side() -> int:
	if socket_type == Types.SocketType.INPUT && socket_direction == Types.SocketDirectionType.PARALLEL:
		return 2
	elif socket_type == Types.SocketType.INPUT && socket_direction == Types.SocketDirectionType.LINEAR:
		return 0
	elif socket_type == Types.SocketType.OUTPUT && socket_direction == Types.SocketDirectionType.PARALLEL:
		return 3
	elif socket_type == Types.SocketType.OUTPUT && socket_direction == Types.SocketDirectionType.LINEAR:
		return 1
	return -1

# Socket Type and Direction
func set_socket_type(socket_type: Types.SocketType):
	self.socket_type = socket_type

func set_direction_type(direction_type: Types.SocketDirectionType):
	self.socket_direction = direction_type

# Set the connected node to the node supplied.
func set_connected_node(node: VXNode):
	connected_node = node
	if not connected_node.node_moved.is_connected(_on_node_moved):
		connected_node.node_moved.connect(_on_node_moved)
	if not connected_node.sockets_updated.is_connected(_on_socket_updated):
		connected_node.sockets_updated.connect(_on_socket_updated)

## Gets the attached connection.
func get_connected_node() -> VXNode:
	return connected_node

## Deletes a connection and signals the event in the connected node.
func delete_connection():
	if connection != null:
		connection.delete_connection()
	delete()

## Delete this node.
func delete():
	if is_instance_valid(self):
		queue_free()
		connected_node.emit_connection_deleted(self)

# Mouse Events
func _on_mouse_entered() -> void:
	VXGraph.current_focused_socket = self
	is_mouse_over_socket = true
	print(is_mouse_over_socket)

func _on_mouse_exited() -> void:
	VXGraph.current_focused_socket = null
	is_mouse_over_socket = false
	print(is_mouse_over_socket)

# Editing Status
func set_currently_editing(editing: bool):
	is_socket_being_edited = editing

func _on_editing_started(_start_position: Vector2):
	if not is_mouse_over_socket:
		return
	if connection != null:
		connection.delete_connection()
		return
	set_currently_editing(true)
	create_new_connection()

func _on_editing_ended(_end_position: Vector2):
	if not is_socket_being_edited:
		return
	set_currently_editing(false)

# Connection Management
func create_new_connection() -> VXConnection:
	connection = VXGraph.get_instance().create_connection(self)
	return connection

func get_connection_point() -> Vector2:
	return center.global_position

# Signal Handlers
func _on_node_moved(pos: Vector2) -> void:
	node_moved.emit(pos)

func _on_socket_updated() -> void:
	socket_updated.emit()

func emit_new_connection_created(start_socket: VXSocket, end_socket: VXSocket):
	new_connection_created.emit(start_socket, end_socket)

func notify_node_of_new_connection(start_socket: VXSocket, end_socket: VXSocket):
	connected_node.emit_new_connection_created(start_socket, end_socket)
