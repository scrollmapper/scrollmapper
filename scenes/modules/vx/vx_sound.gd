extends Node

@export var node_created: AudioStreamPlayer
@export var node_selected: AudioStreamPlayer
@export var node_deleted: AudioStreamPlayer
@export var connection_deleted: AudioStreamPlayer
@export var connection_created: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.node_created.emit(_on_node_created)
	Signals.node_selected.connect(_on_node_selected)
	Signals.node_deleted.connect(_on_node_deleted)
	Signals.connection_deleted.connect(_on_connection_deleted)
	Signals.connection_created.connect(_on_connection_created)

func _on_node_created() -> void:
	node_created.play()

func _on_node_selected() -> void:
	node_selected.play()

func _on_node_deleted() -> void:
	node_deleted.play()

func _on_connection_deleted() -> void:
	connection_deleted.play()

func _on_connection_created() -> void:
	connection_created.play()
