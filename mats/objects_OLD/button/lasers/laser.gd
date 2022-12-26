extends Position2D
var g =Global
func _ready():
	pass # Replace with function body.
onready var r=$r
export(float)var w=5
func _process(delta):
	if r.is_colliding():
		var rt=r.get_collision_point()-global_position
		var leight=sqrt(rt.x*rt.x+rt.y*rt.y)
		var e=PoolVector2Array([Vector2(0,w),Vector2(leight,w),Vector2(leight,-w),Vector2(0,-w)])
		if $p/col.polygon!=e:
			$p/col.polygon=e
		$img.scale=Vector2(leight,w*2)/($img.texture.get_size()*Vector2(1,$img.material.get("shader_param/thickness")+$img.material.get("shader_param/outline_thickness")))

	else:
		var leight=r.cast_to.x
		var e=PoolVector2Array([Vector2(0,w),Vector2(leight,w),Vector2(leight,-w),Vector2(0,-w)])
		if $p/col.polygon!=e:
			$p/col.polygon=e
		$img.scale=Vector2(leight,w*2)/($img.texture.get_size()*Vector2(1,$img.material.get("shader_param/thickness")+$img.material.get("shader_param/outline_thickness")))

