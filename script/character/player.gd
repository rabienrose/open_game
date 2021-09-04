extends character

func _ready():
    ai_status=load("res://script/ai/control_move.gd").new()
    ai_status.host=self
    ai_status.world=world   
    chara_type="player"
    

