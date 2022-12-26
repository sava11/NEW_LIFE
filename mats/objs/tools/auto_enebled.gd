extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	if bs==[]:get_parent().enebled=false
	else:get_parent().enebled=true

var bs=[]
func _on_a_body_entered(b):
	if Global.i_search(bs,b)==-1:
		bs.append(b)
	pass # Replace with function body.


func _on_a_body_exited(b):
	bs.remove(Global.i_search(bs,b))
	pass # Replace with function body.
