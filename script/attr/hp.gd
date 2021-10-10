extends num_attr

export var max_hp=0
var hp

func get_val():
    return hp   

func on_create(world_, owner_):
    .on_create(world_, owner_)
    tick_hz_mode="none"
    owner.hp_bar.max_value=max_hp
    hp=max_hp

func tick(delta):
    pass

func add_hp(val):
    if hp+val>max_hp:
        hp=max_hp
    else:
        hp=hp+val

func update_hp():
    owner.hp_bar.texture_progress = owner.bar_green
    if hp < max_hp * 0.7:
        owner.hp_bar.texture_progress = owner.bar_yellow
    if hp < max_hp * 0.35:
        owner.hp_bar.texture_progress = owner.bar_red
    owner.hp_bar.value = hp
    if hp<max_hp:
        owner.hp_bar.visible=true
    else:
        owner.hp_bar.visible=false
    
func on_dead(attcker):
    owner.dead=true
    if attcker!=null:
        if "kill_count" in attcker.attrs:
            attcker.attrs["kill_count"].set_val(attcker.attrs["kill_count"].get_val()+1)
        var gift_res = world.gift_mgr.get_rand_gift()
        gift_res.apply_gift(attcker)
        attcker.fct_mgr.show_value(gift_res.desc, true)
    if attcker!=null:
        world.msg.emit_signal("chara_die", attcker.name, attcker.attrs["kill_count"].get_val(), owner.name)  
    else:
        world.msg.emit_signal("chara_die", "", -1, owner.name)   
    world.map.on_chara_remove(owner)
    owner.queue_free()
    if owner.is_player==true:
        world.msg.emit_signal("game_over")   

func apply_damage(val, attacker):
    if attacker!= null and attacker.dead==true:
        return
    owner.fct_mgr.show_value(str(val))
    hp=hp-val
    if hp<=0:
        on_dead(attacker)
        return
    update_hp()

