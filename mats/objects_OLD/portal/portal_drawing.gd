extends Node2D
var color=Color(0,0,0)
var width=1
var to_portal=null
var portals_list=[]
func _draw():
	for p in portals_list:
		draw_line(Vector2.ZERO,p.position-self.position,color,width)
func _process(delta):
	update()
