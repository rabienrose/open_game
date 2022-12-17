extends Area2D

class_name bullet

var speed = 200
var bullet_range = 200

var cul_dis=0
var sender
var b_bullet=true

func on_create(_bullet_spd, _bullet_range):
	bullet_range=_bullet_range
	speed=_bullet_spd

func shot(sender_, src_posi, rot):
	sender=sender_
	rotation_degrees=rot
	position=src_posi

func _physics_process(delta):
	if not Global.check_unit_valid(sender):
		queue_free()
		return
	if cul_dis/Global.tile_size>bullet_range:
		queue_free()
	position += transform.x * speed * delta
	z_index=position.y/10
	cul_dis=cul_dis+speed * delta

func on_area_entered(area):
	var body_tmp=area.get_parent()
	if not Global.check_unit_valid(sender):
		queue_free()
		return
	if body_tmp==sender:
		return
	if "b_bullet" in body_tmp: #is bullet
		return
	if "hp" in body_tmp: #is char
		body_tmp.apply_damage(sender)
	queue_free()
