extends Position2D
var g =Global
func _ready():
	pass # Replace with function body.
onready var r=$r
export(float)var w=5
export(float)var graw_speed=750
export(float,-1,1)var sp_sc=1
export(Color)var colA
export(Color)var colB
var col2=Color(0,0,0,1)
var bodys=[]
func adfqu():
	pass
func transform_2colors():
	var cvec1=Vector3(colA.r,colA.g,colA.b)
	var cvec2=Vector3(colB.r,colB.g,colB.b)
	var cvec=(cvec2-cvec1)*(sp_sc+1)/2
	modulate=Color(colA.r+cvec.x,colA.g+cvec.y,colA.b+cvec.z,1)
func _process(delta):
	transform_2colors()
	if r.is_colliding():
		var rt=r.get_collision_point()-global_position
		var leight=sqrt(rt.x*rt.x+rt.y*rt.y)
		var e=PoolVector2Array([Vector2(0,w),Vector2(leight,w),Vector2(leight,-w),Vector2(0,-w)])
		if $p/col.polygon!=e:
			$p/col.polygon=e
		$img.scale=Vector2(leight,w*2)/$img.texture.get_size()
		$img.position=Vector2(0,-w)
	else:
		var leight=r.cast_to.x
		var e=PoolVector2Array([Vector2(0,w),Vector2(leight,w),Vector2(leight,-w),Vector2(0,-w)])
		if $p/col.polygon!=e:
			$p/col.polygon=e
		$img.scale=Vector2(leight,w*2)/$img.texture.get_size()
		$img.position=Vector2(0,-w)
	if bodys!=[]:
		for b in bodys:
			if b==get_tree().current_scene.ch:
				b.set_linear_velocity((Vector2(cos(rotation),sin(rotation))+b.vel/(b.speed/graw_speed))*graw_speed*sp_sc)
				b.can_jump=true
			else:
				b.set_linear_velocity(Vector2(cos(rotation),sin(rotation))*graw_speed*sp_sc)

func in_graw(body):
	if body is RigidBody2D:
		bodys.append(body)
	pass # Replace with function body.


func out_graw(body):
	if body is RigidBody2D:
		bodys.remove(bodys.find(body))
	pass # Replace with function body.
