extends bullet

export (Resource) var split_fab

func new_split_bullet(area,angle):
    var new_bullet = split_fab.instance()
    new_bullet.ignore_chara=area
    new_bullet.shot(sender, position, rotation_degrees+angle)
    get_node("/root/game/world/bullets").add_child(new_bullet)

func on_area_entered(area):  
    if not is_instance_valid(sender):
        return
    if area==sender:
        return
    if area==ignore_chara:
        return
    if not "attrs" in area:
        return
    .on_area_entered(area)
    new_split_bullet(area,0)
    new_split_bullet(area,20)
    new_split_bullet(area,-20)
    
    
