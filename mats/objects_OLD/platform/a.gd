extends CollisionPolygon2D
export(Color) var collor=Color(0,0,0,1)
var p=[]
export(Texture) var texture=preload("res://matireals/objects/platform/sampleNoise.tres")
export(bool)var textured=true
func _ready():
	for z in polygon:
		p.append(z*scale)
	var poli=Polygon2D.new()
	if textured!=false:
		poli.texture=texture
	poli.color=collor
	poli.polygon=p
	add_child(poli)
