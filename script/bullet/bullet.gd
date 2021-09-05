extends Area2D

var speed = 250
var bullet_range = 200
var cul_dis=0
var sender

func _physics_process(delta):
    
    if cul_dis>bullet_range:
        queue_free()
    position += transform.x * speed * delta
    cul_dis=cul_dis+speed * delta

func _on_fireball_area_entered(area):
    if not is_instance_valid(sender):
        return
    if area==sender:
        return
    if area.is_in_group("chara"):
        area.apply_damage(sender.atk, sender)
        queue_free()
