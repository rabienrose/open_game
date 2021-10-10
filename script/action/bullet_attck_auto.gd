extends action_base

var atk_target=null
var atk_position=null
var skill=null
export(int) var skill_slot

func on_create(world_, owner_):
    .on_create(world_, owner_)
    if owner.skills.size()>skill_slot:
        skill=owner.skills[skill_slot]

func do(delta):
    if atk_target==null and atk_position==null:
        return
    if skill.can_use():
        if atk_position==null:
            if is_instance_valid(atk_target):
                skill.place_skill(atk_target.position)
            else:
                atk_target=null
        else:
            skill.place_skill(atk_position)
   
func set_atk_position(position_):
    atk_position=position_
            
func cal_score():
    var charas = world.map.get_near_characters(owner.position, 5, 10, owner)
    for chara in charas:
        if not is_instance_valid(chara):
            continue
        var dis = (chara.position-owner.position).length()
        var atk_range=128
        if "atk_range" in owner.attrs:
            atk_range=owner.attrs["atk_range"].get_val()
        if dis < atk_range-20 and world.map.check_ray(owner, chara):
            atk_target=chara
            return 20
    return -10

