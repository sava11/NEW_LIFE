extends StaticBody2D
var in_=false
var ba
export(Color) var collor=Color()
func clean():
	if ba!=null:
		$pj.node_a=$pj.get_path()
		ba.mode=RigidBody2D.MODE_CHARACTER
		ba.rotation_degrees=0
		ba.on_pl=false
		ba=null
func _draw():
	draw_circle(Vector2(0,0),$col.shape.radius,collor)
func _process(delta):
	if ba!=null:
		#var walk = (Input.get_action_strength("right") - Input.get_action_strength("left")) 
		#var walk=get_tree().current_scene.get_node("CanvasLayer/Control/s/tb").get_value().x
		#var rg = (global_position-ba.global_position)
		#var ang=(180/PI)*-atan2(-rg[1], rg[0])+(90*walk)
		if in_==false:
			ba.on_pl=true
			$pj.node_a=ba.get_path()
			ba.mode=RigidBody2D.MODE_RIGID
			in_=true
		if Input.is_action_just_pressed("space") and ba!=null:
			#ba.set_linear_velocity(Vector2(cos(deg2rad(ang)),sin(deg2rad(ang)))*ba.F)
			$pj.node_a=$pj.get_path()
			ba.rotation_degrees=0
			ba.mode=RigidBody2D.MODE_CHARACTER
	else:
		$pj.node_a=$pj.get_path()
func in_p(b):
	var rg = (global_position-b.global_position)
	var ang=(180/PI)*-atan2(-rg[1], rg[0])
	b.set_linear_velocity(Vector2(0,0))
	b.global_position=global_position-Vector2(cos(deg2rad(ang)),sin(deg2rad(ang)))*30
	
	b.rotation_degrees=ang+90
	ba=b
	ba.on_pl=true
	in_=false
func _on_a_body_exited(b):
	ba=null
	b.on_pl=false
