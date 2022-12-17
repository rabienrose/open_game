extends Control

export (NodePath) var label_path

func _ready():
	pass

func set_content(text):
	get_node(label_path).text=text
	
