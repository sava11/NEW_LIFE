extends LineEdit

var g=Global
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		var t=text.split(" ")
		if t[0]=="9870" and len(t)==2 and  g.get_hero()!=null and (t[1].to_float()!=0 or str(t[1].to_float())==t[1]):
			g.get_hero().get_node("stats").set_he(g.get_hero().get_node("stats").he+t[1].to_float())
		if t[0]=="0969" and len(t)==2 and(t[1].to_float()!=0 or str(t[1].to_float())==t[1]):
			Global.get_hero().MultiJumpMaxValue=ceil(t[1].to_float())
		
		text=""
	pass


func _on_console_mouse_entered():
	get_tree().paused=true
	editable=true
	pass # Replace with function body.


func _on_console_mouse_exited():
	get_tree().paused=false
	editable=false
	pass # Replace with function body.
