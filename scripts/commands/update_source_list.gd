@tool
extends Node

## Command to download the source list using ResourceDownloader.
func execute(command_string: String):
	if Engine.is_editor_hint():
		Command.print_to_console("Command not available in editor.")
		return
	ResourceDownloader.instance.retrieve_source_list()
	print("Source list download initiated.")
