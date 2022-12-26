extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(bool)var open=true
onready var p=$p
# Called when the node enters the scene tree for the first time.
func _ready():
	$p2.polygon=$pVera/c.polygon
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if open==true:$p.emitting=true
	else:$p.emitting=false
	var ang=Global.angle($vel.shape.b)
	var pull=Global._sqrt($vel.shape.b)
	p.rotation_degrees=(180/PI)*ang+90
	p.process_material.linear_accel=pull/5
	pass
func _on_pVera_body_entered(b):
	if open==true:
		if b is RigidBody2D:
			var v=$vel.shape.b
			var gr=b.gr_power
			#v.y=g(t*t)/2
			#var t=Global.fabs(v.y)/Global.move(Global.angle(b.get_graw())-rotation,b.gr_power*60).y*2
			#print(t)
			var pull=Global._sqrt(v)
			var ang=Global.angle(v)
			#var graw=Global.move(Global.angle(b.get_graw())-rotation,b.gr_power*60).y*(t*t)/2
			var vel=Vector2(cos(ang),sin(ang))*pull
			b.set_linear_velocity(vel)
		#print(b.get_linear_velocity(),ang)
	pass # Replace with function body.
