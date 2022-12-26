extends Area2D
var V=Vector2(0,17)
export(Array)var lvls=[]
var open=false
export(Color)var color
export(float)var width=1
export(NodePath)var to_portal=null

var portals_list=[]
onready var sp=Sprite.new()
onready var vc=get_tree().current_scene.get_node("cl/Control/ViewportContainer/Viewport/map")
func _ready():
	if to_portal!=null:
		var n=get_node(to_portal)
		portals_list.append(n)
	sp.texture=load("res://icon.png")
	vc.get_node("portals").add_child(sp)
	sp.global_position=global_position
	sp.set_script(load("res://matireals/objects/portal/portal_drawing.gd"))
	sp.visible=false
	sp.width=width
	sp.color=color
	sp.portals_list=portals_list
	sp.set_process(true)
export(Color) var col=Color(10,10,10,255)
func _draw():
	var pol=[]
	for ep in $col.polygon:
		pol.append(ep)
	draw_colored_polygon(pol,col,PoolVector2Array(),null,null,true)
var in_=false

func _process(delta):
	update()
	if open==true and sp.visible==false:
		sp.visible=true
	if Input.is_action_just_pressed("e") and in_==true and get_tree().paused==false:
		Global.emit_signal("save")
func _on_p1_body_entered(b):
	if Global._search(Global.portals_ids,self.get_index())==-1:
		Global.portals_ids.append(get_index())
		open=true
	in_=true
	pass


func _on_p1_body_exited(b):
	in_=false
	pass
