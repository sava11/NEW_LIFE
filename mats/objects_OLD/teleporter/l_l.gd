extends Node2D
var time =0
var tim=0
var t1=0.5
var go=false
var go1=false
export(NodePath)var node_to
var _in=false
var b=null
func _process(delta):
	if _in==true:
		if Input.is_action_just_pressed("e"):
			if node_to!=null and get_node(node_to)!=null:
				b.global_position=get_node(node_to).global_position
	pass
func _on_a_body_entered(body):
	b=body
	_in=true
	pass # Replace with function body.


func _on_a_body_exited(body):
	b=null
	_in=false
	pass # Replace with function body.
