extends character

func _ready():
    ai_status=load("res://script/ai/move.gd").new()
    ai_status.host=self
    ai_status.world=world   
            
