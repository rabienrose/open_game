extends ai_status_base

func tick(delta):
    if not is_instance_valid(host):
        return null
    if not host.is_moving():
        var e_posi = world.map.get_rand_free_spot()
        host.set_move_tar_posi(e_posi)
    var return_ai=null
    var chara = world.get_near_characters(host, 1000)
    if chara!=null:
        var dis = (chara.position-host.position).length()
        if dis < host.atk_range-20 and world.check_ray(host, chara):
            host.stop_move()
            return_ai = gen_new_status("attack")
            return_ai.tar_char=chara
        else:
            return_ai = gen_new_status("persuit")
            return_ai.tar_chara=chara
    return return_ai
