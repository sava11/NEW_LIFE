extends Node2D

export(float)var y_l
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var open=false
func save():
	var sl={
		"path":get_path(),
		"open":open
	}
func loade(n):
	open=n["open"]
signal changed(node)
signal loado(node)
# Called when the node enters the scene tree for the first time.
func _ready():
	$a/c.shape.extents.y=y_l
	var ext=$a/c.shape.extents
	pass # Replace with function body.
func _on_a_area_entered(a):
	if a.get_parent().is_in_group("lasers"):
		open=true
		emit_signal("changed",self)


func exited(a):
	open=false
	emit_signal("changed",self)
