extends Area2D

var speed = 250
var cul_time=0
var sender

func _physics_process(delta):
    cul_time=cul_time+delta
    if cul_time>1:
        queue_free()
    position += transform.x * speed * delta

func _on_fireball_area_entered(area):
    if not is_instance_valid(sender):
        return
    if area==sender:
        return
    if area.is_in_group("chara"):
        area.apply_damage(sender.atk, sender)
        queue_free()
