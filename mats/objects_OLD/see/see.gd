extends Area2D
var p=null
func can_see():
	return p!=null
func _on_see_body_entered(b):
	p=b

func _on_see_body_exited(body):
	p=null
