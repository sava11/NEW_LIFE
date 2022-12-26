extends Polygon2D
func _ready():
	var v=polygon
	$c/c.polygon=v
	$c/a/c.polygon=v
func _on_a_body_exited(b):
	pass
	#b.collision_mask=257
	#$c.disabled=false




