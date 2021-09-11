extends Node2D

var buf_pool=[]

func _init():
	buf_pool.append({"name":"add_atk","val":10,"desc":"ATK +10"})
	buf_pool.append({"name":"add_atk_spd","val":1,"desc":"ATK SPD +1"})
	buf_pool.append({"name":"add_atk_range","val":50,"desc":"RAN +50"})
	buf_pool.append({"name":"add_mov_speed","val":50,"desc":"SPEED +50"})
	buf_pool.append({"name":"add_hp","val":50,"desc":"HP +50"})
	buf_pool.append({"name":"double_atk","desc":"Atk DOUBLE"})
	buf_pool.append({"name":"double_atk_spd","desc":"ATK SPD DOUBLE"})

func apply_rand_buf(chara):
	var i_rand = randi() % buf_pool.size()
	var buf_info=buf_pool[i_rand]
	if buf_info["name"]=="add_atk":
		chara.atk=chara.atk+buf_info["val"]
	elif buf_info["name"]=="add_atk_spd":
		chara.atk_spd=chara.atk_spd+buf_info["val"]
	elif buf_info["name"]=="add_hp":
		chara.hp=chara.hp+buf_info["val"]
		if chara.hp>chara.max_hp:
			chara.hp=chara.max_hp
	elif buf_info["name"]=="double_atk":
		chara.atk=chara.atk*2
	elif buf_info["name"]=="double_atk_spd":
		chara.atk_spd=chara.atk_spd*2
	elif buf_info["name"]=="add_atk_range":
		chara.atk_range=chara.atk_range+buf_info["val"]
	elif buf_info["name"]=="add_mov_speed":
		chara.speed=chara.speed+buf_info["val"]
	chara.fct_mgr.show_value(buf_info["desc"], true)
	
