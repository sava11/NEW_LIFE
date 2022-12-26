extends Position2D
export(float,0,360)var angle=90
export(int,2,128)var rays=3
export(float)var sector_rad=5000
export(int)var coll_layer=1
export(bool)var update_=false
export(bool)var add_rays=false
var g=Global
func _ready():
	_add_pols()
	pass
func _add_pols():
	var pol=PoolVector2Array([])
	for e in range(0,rays):
		pol.append(g.move(angle/(rays-1)*e-angle/2)*sector_rad)
	pol.append(Vector2(0,0))
	#p.polygon=pol
onready var p=$p
func _check():
	if $rays.get_child_count()>rays:
		for e in range(0,rays-$rays.get_child_count()):
			$rays.get_child($rays.get_child_count()-1-e).queue_free()
			p.polygon.remove($rays.get_child_count()-1-e)
	if $rays.get_child_count()<rays:
		var pol=PoolVector2Array([])
		for r in $rays.get_children():
			r.queue_free()
		for e in range(0,rays):
			var r=RayCast2D.new()
			$rays.add_child(r)
			r.enabled=true
			r.cast_to=Vector2(sector_rad,0)
			r.rotation_degrees=angle/(rays-1)*e-angle/2
			r.set_process(true)
			pol.append(g.move(r.rotation_degrees)*sector_rad)
		pol.append(Vector2(0,0))
		p.polygon=pol
func _physics_process(delta):
	if update_==true:
		_check()
		for r in $rays.get_children():
			r.cast_to=Vector2(sector_rad,0)
			var rid=$rays.get_children().find(r)
			r.rotation_degrees=angle/(rays-1)*rid-angle/2
			if r.is_colliding():
				p.polygon[rid]=g.move(r.rotation_degrees)*g._sqrt(r.get_collision_point()-r.global_position)
