extends ai_status_base

class_name idle_status

func tick(delta):
    if not is_instance_valid(owner):
        return null
    if not owner.is_moving():
        var e_posi = world.map.get_rand_spot(1,false, true)[0]
        e_posi=world.map.convert_c_to_m_pos(e_posi)
        owner.set_move_tar_posi(e_posi)
    var return_ai=null
    var chara = world.map.get_near_characters(owner, 5,1)
    if chara!=null:
        var dis = (chara.position-owner.position).length()
        if dis < owner.atk_range-20 and world.check_ray(owner, chara):
            owner.stop_move()
            return_ai = gen_new_status("attack")
            return_ai.tar_char=chara
        else:
            return_ai = gen_new_status("persuit")
            return_ai.tar_chara=chara
    return return_ai
