extends Position2D
var g =Global
func _ready():
	pass # Replace with function body.
onready var r=$p/s/r
var w=5
func _process(delta):
	if r.is_colliding():
		var rt=r.get_collision_point()-global_position
		var leight=sqrt(rt.x*rt.x+rt.y*rt.y)
		var e=PoolVector2Array([Vector2(0,w),Vector2(leight,w),Vector2(leight,-w),Vector2(0,-w)])
		if $p.polygon!=e:
			$p.polygon=e
			$p/s/c.polygon=e
	else:
		var leight=r.cast_to.x
		var e=PoolVector2Array([Vector2(0,w),Vector2(leight,w),Vector2(leight,-w),Vector2(0,-w)])
		if $p.polygon!=e:
			$p.polygon=e
			$p/s/c.polygon=e
	pass
