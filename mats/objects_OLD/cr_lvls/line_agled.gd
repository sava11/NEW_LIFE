extends Polygon2D
export(Vector2)var alfp=Vector2(0,0)
export(float)var afp=0
export(Vector2)var rot=Vector2(0,25)
export(Vector2)var self_rot=Vector2(-90,0)
export(bool)var rotating=false
export(int)var coll_layer=1
export(float)var w=1
export(PoolVector2Array) var lines
var g=Global
func _ready():
	var pol=PoolVector2Array([])
	for e in lines:
		pol.append(g.move(e.x+90)*e.y)
	if w!=0:
		for o in range(0,len(lines)):
			var i=lines[len(lines)-o-1]
			pol.append(g.move(i.x+90)*(i.y+w))
	polygon=pol
	$s/c.polygon=polygon
	$s.collision_layer=coll_layer
	$s.collision_mask=coll_layer

func _physics_process(delta):
	self.position=g.move(rot.x+alfp.x+90)*alfp.y
	if rotating==true:
		rot.x+=rot.y*delta
		self_rot.x+=self_rot.y*delta
		if position!=Vector2.ZERO:
			var rt=(180/PI)*g.angle(self.position)+(self_rot.x-alfp.x)
			self.rotation_degrees=rt
		else:
			var rt=(self_rot.x-alfp.x)
			self.rotation_degrees=rt
	
