extends bullet

export (Resource) var split_fab

func new_split_bullet(area,angle):
    var new_bullet = split_fab.instance()
    new_bullet.ignore_chara=area
    new_bullet.shot(sender, position, rotation_degrees+angle)
    get_node("/root/game/world/bullets").add_child(new_bullet)

func on_area_entered(area):  
    var body_tmp=area.get_parent()
    if not is_instance_valid(sender):
        return
    if body_tmp==sender:
        return
    if body_tmp==ignore_chara:
        return
    if not "attrs" in body_tmp:
        return
    .on_area_entered(area)
    new_split_bullet(body_tmp,0)
    new_split_bullet(body_tmp,20)
    new_split_bullet(body_tmp,-20)
    
    
