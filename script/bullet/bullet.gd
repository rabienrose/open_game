extends Area2D

class_name bullet

export var speed = 250
export var bullet_range = 200

var cul_dis=0
var sender
var ignore_chara=null


func shot(sender_, src_posi, rot):
    sender=sender_
    rotation_degrees=rot
    position=src_posi

func _physics_process(delta):
    if cul_dis>bullet_range:
        queue_free()
    position += transform.x * speed * delta
    cul_dis=cul_dis+speed * delta

func on_area_entered(area):
    var body_tmp=area.get_parent()
    if not is_instance_valid(sender):
        return
    if body_tmp==sender:
        return
    if body_tmp==ignore_chara:
        return
    
    if "attrs" in body_tmp:
        if ("hp" in body_tmp.attrs) and ("atk" in sender.attrs):
            body_tmp.attrs["hp"].apply_damage(sender.attrs["atk"].get_val(), sender)
        queue_free()
