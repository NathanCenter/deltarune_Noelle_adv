extends Control

@onready var label = $Panel/NinePatchRect/MarginContainer/HBoxContainer/Label
@onready var timer = $Timer  # add a Timer node as a child
@onready var portrait = $Panel/NinePatchRect/MarginContainer/HBoxContainer/TalkingHead
var full_text = ""
var char_index = 0
var typing = false
var portraits = {
	"noelle": preload("res://talking_head/noellee/noelle_heads_clean_nopink_sigel_happy.png")
	# add more characters here if needed
}
var current_speaker: String = ""
func show_text(message: String,speaker: String = ""):
	full_text = message
	char_index = 0
	label.text = ""
	typing = true
	show()
	timer.start(0.03)  # 0.03 seconds per letter (adjust speed)
	# show or hide portrait based on speaker
	if portraits.has(speaker):
		portrait.texture = portraits[speaker]
		portrait.visible = true
	else:
		portrait.visible = false
		
func _on_timer_timeout():
	if char_index < full_text.length():
		label.text += full_text[char_index]
		char_index += 1
	else:
		typing = false
		timer.stop()
