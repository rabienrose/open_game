extends Object
class_name world

var all_characters=[]
var all_bullets=[]
var cam
var spawn
var map
var node

func init():
    map = load("res://assets/prefab/map.tscn").instance()
    node.add_child(map)
    spawn = load("res://assets/prefab/spawn.gd").new()
    spawn.map=map
    spawn.world=self
    var new_chars = spawn.batch_spwan(50)
    all_characters.extend(new_chars)

func add_new_bullet():
    pass

func add_new_character(sprite_name):
    pass
    
func remove_character(player):
    pass

func get_near_characters(tar_posi):
    pass
