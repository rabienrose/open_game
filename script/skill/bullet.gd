extends skill_base

export(Resource) var bullet_fab
var last_use_time=0


func can_use():
    var atk_spd=2
    if "atk_spd" in owner.attrs:
        atk_spd=owner.attrs["atk_spd"].get_val()
    var cur_time = OS.get_ticks_msec()/1000.0
    if cur_time-last_use_time>1.0/atk_spd:
        last_use_time=cur_time
        return true
    else:
        return false

func place_skill(pos_m):
    var new_bullet= bullet_fab.instance()
    var distance = pos_m - owner.position
    var dir=distance.normalized()
    owner.set_direction("stand",dir)
    var src_posi = owner.get_fire_position()
    var rot=atan2(dir.y,dir.x)*180/3.1415926
    var atk_range=128
    if "atk_range" in owner.attrs:
        atk_range=owner.attrs["atk_range"].get_val()
    new_bullet.bullet_range=atk_range
    world.get_node("bullets").add_child(new_bullet)
    new_bullet.shot(owner, src_posi, rot)




