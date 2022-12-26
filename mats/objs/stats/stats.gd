extends Node
export(float) var m_he=1 setget s_m_h
export(float,0.001,10) var rgen_speed=1
var he=m_he setget set_he
export(float) var m_en=1 setget s_m_en
export(float,0.001,10) var engen_speed=1
var en=m_en setget set_en
signal no_he
signal h_ch(v)
signal m_h_ch(v)
func s_m_h(v):
	m_he=v
	self.he=min(he,m_he)
	emit_signal("m_h_ch",m_he)
func set_he(value):
	he=value
	emit_signal("h_ch",he)
	if he<=0:
		emit_signal("no_he")
	elif he>m_he:he=m_he

signal no_en
signal en_ch(v)
signal m_en_ch(v)
func s_m_en(v):
	m_en=v
	self.en=min(en,m_en)
	emit_signal("m_en_ch",m_en)
func set_en(value):
	en=value
	emit_signal("en_ch",en)
	if en<=0:
		emit_signal("no_en")
	elif en>m_en:en=m_en

func _ready():
	self.he=m_he
func _physics_process(delta):
	if self.he<self.m_he:set_he(self.he+self.rgen_speed*delta)
	else:self.he=self.m_he
