extends Position2D
enum type {Havy,small}
export(type)var t=type.small
export(float)var gr_power=100
export(float)var gr_ang=90
enum list{norm,bridge,laserd,laseru,graw}
export(list) var m=0
export(int)var conect_nod
func _ready():
	var can=false
	for e in Global.sn:
		if e.has("pathm"):
			if e["id"][0]==str(get_path()) and e["id"][1]==conect_nod:
				can=true
	if can==false:
		var cube=preload("res://matireals/objects/rect/rb.tscn").instance()
		get_parent().call_deferred("add_child",cube)
		cube.t=t
		cube.gr_power=gr_power
		cube.gr_ang=gr_ang
		cube.m=m
		cube.set_deferred("global_position",global_position)
		cube.con_nod=[get_path(),conect_nod]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
