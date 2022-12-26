extends Polygon2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var col=CollisionPolygon2D.new()
	col.polygon=polygon
	col.name="col"
	get_parent().add_child(col)

