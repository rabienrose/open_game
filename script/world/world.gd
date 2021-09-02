extends Object
class_name world

var cam
var spawn
var map
var node
var bullet_res

func init():
    map = load("res://assets/prefab/map.tscn").instance()
    node.add_child(map)
    spawn = load("res://script/world/spawn.gd").new()
    spawn.init(self)
    cam=load("res://assets/prefab/cam_pan.tscn").instance()
    node.add_child(cam)
    spawn.batch_spwan(50,"mob")
    bullet_res=load("res://assets/prefab/bullet.tscn")
    spawn.spawn_a_player(cam.position, "player")

func get_all_characters():
    pass

func get_all_bullets():
    pass

func add_new_bullet(posi, rot):
    var b = bullet_res.instance()
    node.add_child(b)
    b.rotation_degrees=rot
    b.position = posi
func add_new_character(sprite_name):
    pass
    
func remove_character(player):
    pass

func get_near_characters(tar_posi):
    pass
