aaaaaaaaaaaextends Area2D
export(float) var damage=1
export(float) var scale_damage=1
export(float) var shout_out_scale=1
export(float)var speed=100
var vel=Vector2.ZERO
func _on_hitbox_body_entered(body):
	get_parent().queue_free()
