extends BaseModel

## This is the M2M (many-to-many) model for the graph-connection relationship.

class_name VXGraphConnectionModel

#region Main variables...
var graph_id: int = 0
var connection_id: int = 0
var start_node_side: int = 0
var end_node_side: int = 0
var start_node_socket_index: int = 0
var end_node_socket_index: int = 0
#endregion

func _init():
	super._init()
	create_table()

func get_create_table_query() -> String:
	return """
	CREATE TABLE IF NOT EXISTS vx_graph_connections (
		graph_id INTEGER,
		connection_id INTEGER,
		start_node_side INTEGER,
		end_node_side INTEGER,
		start_node_socket_index INTEGER,
		end_node_socket_index INTEGER,
		FOREIGN KEY(graph_id) REFERENCES graphs(id),
		FOREIGN KEY(connection_id) REFERENCES connections(id),
		PRIMARY KEY (graph_id, connection_id)
	);
	"""

func save():
	# Check if graph-connection relationship already exists
	var query = "SELECT * FROM vx_graph_connections WHERE graph_id = ? AND connection_id = ?;"
	var result = get_results(query, [graph_id, connection_id])
	
	if result.size() == 0:
		# Insert new graph-connection relationship
		var insert_query = """
		INSERT INTO vx_graph_connections 
		(graph_id, connection_id, start_node_side, end_node_side, start_node_socket_index, end_node_socket_index) 
		VALUES (?, ?, ?, ?, ?, ?);
		"""
		execute_query(insert_query, [graph_id, connection_id, start_node_side, end_node_side, start_node_socket_index, end_node_socket_index])

func get_connections_by_graph(graph_id: int) -> Array:
	var query = "SELECT connection_id, start_node_side, end_node_side, start_node_socket_index, end_node_socket_index FROM vx_graph_connections WHERE graph_id = ?;"
	return get_results(query, [graph_id])

func delete():
	if graph_id != null and connection_id != null:
		var query = "DELETE FROM vx_graph_connections WHERE graph_id = ? AND connection_id = ?;"
		execute_query(query, [graph_id, connection_id])
	else:
		print("Graph ID or Connection ID is not set, cannot delete the relationship.")
