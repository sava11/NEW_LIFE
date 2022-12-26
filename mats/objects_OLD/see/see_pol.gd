extends Area2D
export(float,0,360)var angle=90
export(int,2,128)var rays=3
export(float)var sector_rad=5000
var g=Global
func _ready():
	_add_pols()
	$r.cast_to=Vector2(sector_rad,0)
func _add_pols():
	var pol=PoolVector2Array([])
	for e in range(0,rays):
		pol.append(g.move(angle/(rays-1)*e-angle/2)*sector_rad)
	pol.append(Vector2(0,0))
	$c.polygon=pol
	
