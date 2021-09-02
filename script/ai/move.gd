extends ai_status_base

func tick(delta):
    if not host.is_moving():
        var e_posi = world.map.get_rand_free_spot()
        host.set_move_tar_posi(e_posi)
