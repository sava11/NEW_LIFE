extends Button
onready var asp=$asp
func _ready():
	pass # Replace with function body.
func _on_button_down():
	if asp.stream!=null:
		asp.play()
