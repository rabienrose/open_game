extends Node2D

class_name player_control_joy

var character
var msg
var map
var cam
var skill_down=false
var is_moving=false

func on_skill_down(skill_type):
	if not is_instance_valid(character):
		return
	var skill = character.skills[0]
	if skill.can_use():
		var charas = map.get_near_characters(character.position, 5, 10, character)
		var has_target=false
		for chara in charas:
			if not is_instance_valid(chara):
				continue
			var dis = (chara.position-character.position).length()
			var atk_range=128
			if "atk_range" in character.attrs:
				atk_range=character.attrs["atk_range"].get_val()
			if dis < atk_range-20 and map.check_ray(character, chara):
				skill.place_skill(chara.position)
				has_target=true
		if has_target==false:
			skill.place_skill(character.position+character.direction)
	skill_down=true

func on_skill_up(skill_type):
	skill_down=false

func _physics_process(delta):
	pass

			
func _ready():
	pass
	
	


