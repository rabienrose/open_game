extends character

var target_pos


func _ready():
    ai_status=load("res://script/ai/idle.gd").new()
    ai_status.host=self
    ai_status.world=world   
    chara_type="mob"

func _physics_process(delta):
    pass

func _draw():
    if target_pos:
        draw_line(Vector2(0, -20), target_pos - position+Vector2(0, -20), Color(1.0, .329, .298))
            
