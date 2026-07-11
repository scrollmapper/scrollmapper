extends CanvasLayer

## This is the main editor for the VX system. It will be responsible for handling
## anything involved in editing. It is distinct from VXGraph in that it is responsible 
## for the general editor itself, while VXGraph is responsible for the graphing UI and related data.

class_name VXEditor

@export_group("Main Connections")
@export var vx_graph:VXGraph
@export var vx_camera_2d: Camera2D
@export var vx_search_and_execute: VXSearchAndExute 
@export var cursor:TextureRect

@export_group("Dialogues")
## Settings dialog that is responsible for name and description of a given graph.
@export var dialogues:Array[MarginContainer] = []
@export var dialogues_anchor: MarginContainer
@export var blocker_panel:Panel
@export var settings_dialog: SettingsDialogue
@export var delete_graph_dialogue: DeleteGraphDialogue
@export var new_graph_dialogue: MarginContainer
@export var load_graphs_dialogue: LoadGraphsDialogue 
@export var node_control_dialogue: MarginContainer 
@export var meta_control_dialogue: MetaControlDialogue 

static var drag_start_position: Vector2 = Vector2()
var is_dragging: bool = false
var is_dragging_allowed: bool = false
var starting_drag_position: Vector2 = Vector2.ZERO
var starting_drag_position_global: Vector2 = Vector2.ZERO

func _ready():
	
	UserInput.double_clicked.connect(_on_mouse_double_clicked)
	UserInput.mouse_drag_started.connect(_on_mouse_drag_started)
	UserInput.mouse_drag_ended.connect(_on_mouse_drag_ended)

	UserInput.mouse_wheel_increased.connect(_on_mouse_wheel_increased)
	UserInput.mouse_wheel_decreased.connect(_on_mouse_wheel_decreased)

	UserInput.mouse_drag_started.connect(_on_drag_started)
	
	UserInput.escape_key_pressed.connect(close_all_dialogues)
	vx_search_and_execute.operation_selected.connect(_on_graph_action_selected)
	vx_graph.node_control_opened.connect(open_node_control_dialogue)
	
	#region Dialogues 

	blocker_panel.visibility_changed.connect(_on_blocker_panel_visibility_changed)
	settings_dialog.hide()
	settings_dialog.data_accepted.connect(save_graph)
	delete_graph_dialogue.hide()
	delete_graph_dialogue.delete_graph.connect(delete_graph)
	new_graph_dialogue.hide()
	new_graph_dialogue.create_new_graph_pressed.connect(create_new_graph)
	load_graphs_dialogue.hide()
	load_graphs_dialogue.graph_selected.connect(load_graph)
	node_control_dialogue.hide()
	#endregion 

	# Other
	activate_last_used_graph()

## This function will be called when the editor is ready to load the last used graph.
func activate_last_used_graph()->void:
	await vx_graph.ready # prevents the can't access from null issue

	var last_used_graph_id:Dictionary = MetaService.get_meta_data("last_used_graph_id")
	if last_used_graph_id.has("id") && last_used_graph_id["id"] > 0:
		var full_graph_data:Dictionary = VXService.get_saved_graph(last_used_graph_id["id"])
		if full_graph_data.size() > 0:
			vx_graph.set_full_graph_from_dictionary(full_graph_data)
		else:
			print("Error: Could not load last used graph.")
	else:
		var new_graph:Dictionary = VXService.create_new_empty_graph()
		vx_graph.set_full_graph_from_dictionary(new_graph)

## Gets the current graph name
func get_current_graph_name()->String:
	return vx_graph.graph_name

## Gets the current graph description
func get_current_graph_description()->String:
	return vx_graph.graph_description

## Gets the current graph id
func get_current_graph_id()->int:
	return vx_graph.id

## When the mouse wheel is "increased" the camera zoom is increased. 
func _on_mouse_wheel_increased():
	if VXGraph.is_graph_locked:
		return
	vx_camera_2d.zoom *= 1.1

## When the mouse wheel is "decreased" the camera zoom is decreased.
func _on_mouse_wheel_decreased():
	if VXGraph.is_graph_locked:
		return
	vx_camera_2d.zoom *= 0.9

## This function will be called when the mouse drag is started.
## Will turn processing ON for the moment, for other actions to run.
func _on_mouse_drag_started(position: Vector2):
	set_process(true)
	if is_mouse_over_any_element():
		is_dragging_allowed = false
		return
	if VXGraph.is_graph_locked:
		return
	drag_start_position = position
	is_dragging = true

## This function will be called when the mouse drag is ended.
## Will turn processing OFF.
func _on_mouse_drag_ended(position: Vector2):
	set_process(false)
	is_dragging = false
	is_dragging_allowed = true

## Will be turned off and on when the mouse drag is started and ended.
func _process(_delta: float):
	if is_dragging:
		var mouse_position: Vector2 = get_viewport().get_mouse_position()
		var drag_offset: Vector2 = (mouse_position - drag_start_position) / vx_camera_2d.zoom
		drag_start_position = mouse_position
		
		# Check if the mouse is over a node or socket
		if not is_mouse_over_any_element():
			vx_camera_2d.position -= drag_offset

## Will return true of the mouse is over a VXNode or VXSocket
## Note: This implementation uses a loop, which can be improved to avoid relying on loops.
func is_mouse_over_any_element(include_vx_search_element:bool = true) -> bool:
	if is_mouse_over_area2d():
		return true
	for node:VXNode in get_tree().get_nodes_in_group("nodes"):
		if node.is_mouse_over_node:
			return true
	for socket:VXSocket in get_tree().get_nodes_in_group("sockets"):
		if socket.is_mouse_over_socket:
			return true
	if include_vx_search_element:
		if get_viewport().get_mouse_position().y < vx_search_and_execute.size.y:
			return true
	return false

## Checks to see if the mouse is over any area 2d.
func is_mouse_over_area2d() -> bool:
	var viewport := get_viewport()

	# The mouse begins in viewport/screen coordinates.
	var mouse_viewport_position := viewport.get_mouse_position()

	# Convert it into the world coordinates affected by Camera2D.
	var mouse_world_position := (
		viewport.get_canvas_transform().affine_inverse()
		* mouse_viewport_position
	)

	var query := PhysicsPointQueryParameters2D.new()
	query.position = mouse_world_position
	query.collision_mask = 0xFFFFFFFF
	query.collide_with_areas = true
	query.collide_with_bodies = false

	var space_state := viewport.world_2d.direct_space_state
	var results := space_state.intersect_point(query, 32)

	return not results.is_empty()

## Gets the camera 2D from the VXGraph
func get_camera_2d() -> Camera2D:
	return VXGraph.get_camera_2d()

## Gets the center of the screen according to the camera.
func get_camera_center_point_to_global()->Vector2:
	var camera = get_camera_2d()
	var center_screen = Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2)
	return center_screen

## Sets the cursor position to the given position.
func set_cursor_position(position:Vector2) -> void:
	if VXGraph.is_graph_locked:
		return
	var final_position:Vector2 = position - cursor.size / 2
	cursor.global_position = final_position

## Gets the cursor position
func get_cursor_position() -> Vector2:
	return cursor.global_position

## This function will be called when the VXGraph is ready.
## Resets cursor position. 
func _on_vx_graph_ready() -> void:
	set_cursor_position(Vector2.ZERO)

## This function will be called when the mouse is double clicked.
## It is responsible for setting the cursor position.
func _on_mouse_double_clicked():
	if is_mouse_over_any_element():
		return
	if VXGraph.is_graph_locked:
		return
	var mouse_position:Vector2 = vx_graph.get_global_mouse_position()
	set_cursor_position(mouse_position)

## This function will be called when the mouse drag is started.
func _on_drag_started(pos:Vector2) -> void:
	starting_drag_position = pos
	starting_drag_position_global = vx_camera_2d.get_global_mouse_position()

## Called from 
## This function will be called when an action is selected from the VXSearchAndExecute.
## It behaves as a relay to call the related functions selected.
func _on_graph_action_selected(action_tag:String) -> void:
	match action_tag:
		"graph_settings":
			run_settings_dialogue()
		"graph_save":
			save_graph(vx_graph.graph_name, vx_graph.graph_description)
			vx_graph.print_feedback_note("Graph saved...")
		"graph_load":
			run_load_graph_dialogue()
		"graph_new":
			run_new_graph_dialogue()
		"graph_delete":
			run_delete_graph_dialogue()
		"export_vx_to_cross_references":
			export_vx_to_cross_references()
		"export_vx_to_gephi":
			export_graph_to_gephi()
		"export_cross_references_to_gephi":
			export_cross_references_to_gephi()
		"export_cross_references_to_json":
			export_cross_references_to_json()
		"import_vx_from_json":
			import_cross_references_from_json()
		"export_user_created_cross_references_to_csv":
			export_user_created_cross_references_to_csv()
		"import_user_created_cross_references_from_csv":
			import_user_created_cross_references_from_csv()
		"edit_meta":
			show_meta_control_dialogue()
		"exit":
			exit_to_home()
		_:
			print("Unknown action selected.")

func _on_blocker_panel_visibility_changed() -> void:
	if blocker_panel.is_visible():
		vx_graph.lock_graph(true)
	else:
		vx_graph.lock_graph(false)

## Closes all dialogues. A generic function to clear the screan of windows. 
func close_all_dialogues()->void:
	for dialogue in dialogues:
		dialogue.hide()
	blocker_panel.hide()

## Runs the settings dialogue. Opens it up, shows it. 
func run_settings_dialogue() -> void:
	blocker_panel.show()
	settings_dialog.show()

func run_delete_graph_dialogue() -> void:
	blocker_panel.show()
	delete_graph_dialogue.show()

func run_new_graph_dialogue() -> void:
	blocker_panel.show()
	new_graph_dialogue.show()

func run_load_graph_dialogue() -> void:
	blocker_panel.show()
	load_graphs_dialogue.show()

## Initiates the saving process in VXService
func save_graph(graph_name:String, graph_description:String) -> void:
	vx_graph.graph_name = graph_name
	vx_graph.graph_description = graph_description
	var full_graph:Dictionary = vx_graph.get_full_graph_as_dictionary()
	VXService.save_graph(full_graph)
	close_all_dialogues()

## Initiates a graph deletion.
func delete_graph() -> void:
	vx_graph.delete_graph()
	close_all_dialogues()
	vx_graph.clear_graph()

## Initiates a new graph creation.
func create_new_graph(save:bool) -> void: 
	if save:
		save_graph(vx_graph.graph_name, vx_graph.graph_description)
	close_all_dialogues()
	vx_graph.create_new_graph()

## Initiates a graph loading.
func load_graph(graph_id:int) -> void:
	var full_graph_data:Dictionary = VXService.get_saved_graph(graph_id)
	vx_graph.set_full_graph_from_dictionary(full_graph_data)
	close_all_dialogues()

func open_node_control_dialogue(vx_node:VXNode) -> void:
	blocker_panel.show()
	node_control_dialogue.show()
	node_control_dialogue.initiate(vx_node)

## Initiates the process of exporting the current graph to the cross reference database.
func export_vx_to_cross_references() -> void:
	const EXPORT_CROSS_REFERENCES_FROM_VX = preload("res://scenes/modules/dialogues/export_cross_references_from_vx/export_cross_references_from_vx.tscn")
	var export_window:Node = EXPORT_CROSS_REFERENCES_FROM_VX.instantiate()
	export_window.inititate(vx_graph)
	DialogueManager.create_dialogue(export_window, dialogues_anchor)

## Initiates the process of exporting the current graph to Gephi.
func export_graph_to_gephi() -> void:
	const EXPORT_VX_GRAPH_TO_GEPHI = preload("res://scenes/modules/dialogues/export_cross_references_from_vx/export_vx_graph_to_gephi.tscn")
	var export_window:Node = EXPORT_VX_GRAPH_TO_GEPHI.instantiate()
	export_window.inititate(vx_graph)
	DialogueManager.create_dialogue(export_window, dialogues_anchor)

## Initiates the process of exporting the cross references in database to Gephi.
func export_cross_references_to_gephi() -> void:
	const EXPORT_CROSS_REFERENCES_TO_GEPHI = preload("res://scenes/modules/dialogues/export_cross_references_from_vx/export_cross_references_to_gephi.tscn")
	var export_window:Node = EXPORT_CROSS_REFERENCES_TO_GEPHI.instantiate()
	DialogueManager.create_dialogue(export_window, dialogues_anchor)
 
func export_cross_references_to_json() -> void:
	const EXPORT_CROSS_REFERENCES_TO_JSON = preload("res://scenes/modules/dialogues/export_cross_references_from_vx/export_vx_graph_to_json.tscn")
	var export_window:Node = EXPORT_CROSS_REFERENCES_TO_JSON.instantiate()
	export_window.inititate(vx_graph)
	DialogueManager.create_dialogue(export_window, dialogues_anchor)

func import_cross_references_from_json() -> void:
	const IMPORT_VX_GRAPH_FROM_JSON = preload("res://scenes/modules/dialogues/export_cross_references_from_vx/import_vx_graph_from_json.tscn")
	var import_window:Node = IMPORT_VX_GRAPH_FROM_JSON.instantiate()
	import_window.inititate(vx_graph)
	DialogueManager.create_dialogue(import_window, dialogues_anchor)

func show_meta_control_dialogue() -> void:
	meta_control_dialogue.show()

func exit_to_home() -> void:
	const EXIT_TO_HOME = preload("res://scenes/modules/dialogues/export_cross_references_from_vx/exit_to_home.tscn")
	var exit_to_home_window:Node = EXIT_TO_HOME.instantiate()
	DialogueManager.create_dialogue(exit_to_home_window, dialogues_anchor)

func export_user_created_cross_references_to_csv() -> void:
	const EXPORT_USER_CREATED_CROSS_REFERENCES_TO_CSV = preload("res://scenes/modules/dialogues/export_cross_references_from_vx/export_user_created_cross_references_to_csv.tscn")
	var export_window:Node = EXPORT_USER_CREATED_CROSS_REFERENCES_TO_CSV.instantiate()
	DialogueManager.create_dialogue(export_window, dialogues_anchor)

func import_user_created_cross_references_from_csv() -> void:
	const IMPORT_USER_CREATED_CROSS_REFERENCES_FROM_CSV = preload("res://scenes/modules/dialogues/export_cross_references_from_vx/import_user_created_cross_references_from_csv.tscn")
	var import_window:ImportUserCreatedCrossReferencesFromCsv = IMPORT_USER_CREATED_CROSS_REFERENCES_FROM_CSV.instantiate()
	import_window.initiate(vx_graph)
	DialogueManager.create_dialogue(import_window, dialogues_anchor)
