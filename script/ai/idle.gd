extends ai_status_base

func tick(delta):
    if host.hp>host.max_hp*0.8:
        var players = world.get_near_animeies(host.position)
