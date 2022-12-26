extends Node2D
export(bool)var active=false
export(String)var varible="open"
export(NodePath)var lock=null
export(bool)var open=false
func _ready():
	if lock!=null:
		get_node(lock).objs_to_open.append(self)
func _physics_process(delta):
	if active:
		open=get_parent().get_parent().get(varible)
