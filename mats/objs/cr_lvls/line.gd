extends Polygon2D
export(int)var coll_layer=1
#export(float,-180,180)var gr_ang=90
#export(float)var gr_power=980
func _ready():
	$p/c.polygon=polygon
	$p.collision_layer=coll_layer
	$p.collision_mask=coll_layer
	$p/c.polygon=polygon


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
