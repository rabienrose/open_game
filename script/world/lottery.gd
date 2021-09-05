extends Object

var buf_pool=[]

func _init():
    buf_pool.append({"name":"add_atk","val":10})
    buf_pool.append({"name":"add_atk_spd","val":1})
    buf_pool.append({"name":"add_hp","val":50})
    buf_pool.append({"name":"double_atk"})
    buf_pool.append({"name":"double_atk_spd"})

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
