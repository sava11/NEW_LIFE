extends Control
onready var sl=$slot
onready var bcnt=$buttons/cntn
onready var bng=$buttons/game
onready var bsett=$buttons/sett
onready var bex=$buttons/ex
onready var bem=$emenu
onready var bec=$emenu/c
onready var becws=$emenu/cws
onready var beex=$emenu/ex
onready var sett=$settings
onready var svs=$cell_choise_
onready var slt=$slot
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var g=Global

func ch_():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var win=g.get_prjklt_win()
	var bs=[]
	for i in $buttons.get_children():
		if i.visible==true:
			bs.append(i)
	for e in bs:
		e.rect_size=Vector2(win.x/8,win.y/15)
		e.rect_position=Vector2(g.otstp,(e.rect_size.y+g.otstp)*e.get_index()+g.otstp)*e.rect_scale+Vector2(0,win.y/($buttons.get_child_count()-1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_sett_button_down():g.menu_history.append(g.menu_history_items.sett)


func _on_game_button_down():g.menu_history.append(g.menu_history_items.saves)#g.program_history.append(g.program_history_items.game)


func _on_cntn_button_down():
	g.program_history.append(g.program_history_items.game)
	pass # Replace with function body.
