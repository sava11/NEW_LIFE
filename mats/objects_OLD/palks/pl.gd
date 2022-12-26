extends RigidBody2D
export(Color) var collor=Color()
func _draw():
	draw_circle(Vector2(0,0),$col.shape.radius,collor)
func _ready():
	pass # Replace with function body.
#func _process(delta):
	#var ang=Global.angle(ba.global_position-global_position)
	#ba.global_position=global_position+Vector2(cos(ang),sin(ang))*60
	#ba.rotation_degrees=ang+90
		#ba.on_pl=true
		#$pj.node_a=ba.get_path()
	
		#ba.set_linear_velocity(Vector2(cos(deg2rad(ang)),sin(deg2rad(ang)))*ba.F)
		#$pj.node_b=get_path()
		#ba.rotation_degrees=0
		#ba.mode=RigidBody2D.MODE_CHARACTER
		#ba=null
#func _process(delta):
#	pass


func _on_a_body_entered(b):
	if b==Global.get_hero():
		b.emit_signal("palka_in",self)
		#var ang=Global.angle(b.global_position-global_position)
		#b.set_linear_velocity(Vector2(0,0))
		#print(ang)
		#b.mode=RigidBody2D.MODE_RIGID
		#b.global_position=global_position-Vector2(cos(deg2rad(ang)),sin(deg2rad(ang)))*40
		#b.set("rotation_degrees",ang+90)
		#$pj.node_b="/root/map/players/main_player/player"
		#ba.on_pl=true
	pass # Replace with function body.


func _on_a_body_exited(b):
	if b==Global.get_hero():
		b.emit_signal("palka_out",self)
	pass # Replace with function body.
