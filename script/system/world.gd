extends Node2D

var cam
var spawn
var map
var bullet_res
var lottery_mgr
var ui_rank
var ui_chara_info

func _ready():
	lottery_mgr=get_node("lottery_mgr")
	map = get_node("map")
	spawn = get_node("spawner")
	cam=get_node("cam")
	spawn.batch_spwan(100,"mob")
	bullet_res=load("res://assets/prefab/bullet.tscn")
	spawn.spawn_a_player(cam.position, "mob")
	spawn.spawn_a_player(Vector2(cam.position.x+50, cam.position.y), "player")
	ui_rank=node.get_node("ui/ui_rank")
	ui_rank.world=self
	ui_rank.update_rank_info()
	ui_chara_info=node.get_node("ui/ui_chara_info")

func get_near_characters(tar_char, max_dis):
	var charas = spawn.charactor_root.get_children()
	var min_dis=-1
	var min_chara=null
	for chara in charas:
		if chara ==tar_char:
			continue
		var dis = (tar_char.position-chara.position).length()
		if min_dis==-1 or min_dis>dis:
			min_dis=dis
			min_chara=chara
	if min_dis<max_dis:
		return min_chara
	else:
		return null

func check_ray(src_char, tar_char):
	var space_state = node.get_world_2d().direct_space_state
	var temp_offset=Vector2(0,-20)
	var src_posi=src_char.position+temp_offset
	var tar_posi=tar_char.position+temp_offset
	var result = space_state.intersect_ray(src_posi, tar_posi, [src_char], src_char.collision_layer, true, true)
	if result:
		if result.collider==tar_char:
			return true
	return false

func get_all_bullets():
	pass

func add_new_bullet(posi, rot, atk_range, sender):
	var b = bullet_res.instance()
	b.name="bullet"
	node.add_child(b)
	b.rotation_degrees=rot
	b.position = posi
	b.sender=sender
	b.bullet_range=atk_range
	
func remove_character(player):
	pass
