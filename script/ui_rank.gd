extends Control

var world
export (Array, NodePath) var rank_items_path

func _ready():
	pass

func on_create(_world):
	world=_world

class MyCustomSorter:
	static func sort_ascending(a, b):
		if a[1] > b[1]:
			return true
		return false

func update_rank_info():
	var temp_array=[]
	for item in rank_items_path:
		get_node(item).set_content("")
	for chara in world.units.get_children():
		if Global.check_unit_valid(chara):
			temp_array.append([chara, chara.kill_num])
	temp_array.sort_custom(MyCustomSorter, "sort_ascending")
	var i=0
	for item in temp_array:
		get_node(rank_items_path[i]).set_content(str(item[1])+"  "+item[0].name)
		i=i+1
		if i>=10:
			break
	
