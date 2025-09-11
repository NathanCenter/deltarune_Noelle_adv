extends Area2D

# === Node references ===
@onready var dialog_box: Control = get_tree().current_scene.get_node_or_null("CanvasLayer/DialogueBox")
@onready var dialog_text: Label = dialog_box.get_node_or_null("Panel/NinePatchRect/MarginContainer/HBoxContainer/Label") if dialog_box else null
@onready var talking_head: TextureRect = dialog_box.get_node_or_null("Panel/NinePatchRect/MarginContainer/HBoxContainer/TalkingHead") if dialog_box else null
@onready var player: Node = get_tree().current_scene.get_node_or_null("Player")

# === Dialogue system variables ===
var dialogue_queue: Array = []  
var current_dialogue: Dictionary = {}  
var full_text: String = ""
var char_index: int = 0
var typing: bool = false
var typing_speed: float = 0.05
var typing_timer: float = 0.0

# === Player detection ===
var player_in_range: bool = false

# === Track visits ===
var visit_count: int = 0

func _ready():
	if dialog_box:
		dialog_box.hide()
	if talking_head:
		talking_head.hide()
	if dialog_text:
		dialog_text.text = ""

func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false

func _process(delta: float) -> void:
	# --- Interaction ---
	if player_in_range and Input.is_action_just_pressed("interact"):
		if dialog_box and dialog_box.visible:
			if typing:
				if dialog_text:
					dialog_text.text = full_text
				typing = false
			else:
				advance_dialogue()
		else:
			start_multi_line_dialogue()

	# --- Typing effect ---
	if typing and dialog_text:
		typing_timer += delta
		if typing_timer >= typing_speed:
			typing_timer = 0
			if char_index < full_text.length():
				dialog_text.text += full_text[char_index]
				char_index += 1
			else:
				typing = false

	# --- Debug reset ---
	if Input.is_action_just_pressed("ui_cancel"):
		reset_dialogue()

func start_multi_line_dialogue():
	match visit_count:
		0:
			dialogue_queue = [
				{"text": "Hello Mrs.Dreemurr!", "image": "res://talking_head/noellee/noelle_heads_clean_nopink_sigel_happy.png"},
				{"text": "Hello Noelle..it's so great to see you again!", "image": "res://talking_head/Toriel/torie;_heads_clean_happy.png"},
				{"text": "I was wondering if you could help me with something?", "image": "res://talking_head/noellee/noelle_heads_clean_nopink_sigel_curious.png"},
				{"text": "There's a strange noise coming from the forest...", "image": "res://talking_head/noellee/noelle_heads_clean_nopink_sigel_worried.png"},
				{"text": "Of course my child...I'll be happy to help!", "image": "res://talking_head/Toriel/torie;_heads_clean_sweet_mommy_like.png"},
				{"text": "Thank you so much Mrs.Toriel! Tell Kris I said Hi!", "image": "res://talking_head/noellee/noelle_heads_clean_nopink_sigel_happy.png"},
				{"text": "Oh as soon as they get up I will pass it along", "image": "res://talking_head/Toriel/torie;_heads_clean_happy.png"},
				{"text": "Now run along Noelle... I have work to do.", "image": "res://talking_head/Toriel/torie;_heads_clean_sweet_mommy_like.png"},
			]
		1:
			dialogue_queue = [
				{"text": "Oh, it's you again! How have you been?", "image": "res://talking_head/Toriel/torie;_heads_clean_happy.png"},
				{"text": "I have been doing good Mrs.Toriel", "image": "res://talking_head/noellee/noelle_heads_clean_nopink_sigel_happy.png"},
				{"text": "I was just thinking about that strange noise earlier...", "image": "res://talking_head/Toriel/torie;_heads_clean_happy.png"},
				{"text": "Did you find out what it was?", "image": "res://talking_head/noellee/noelle_heads_clean_nopink_sigel_curious.png"},
				{"text": "Ah yes, the forest is peaceful now. Thank you for letting me know.", "image": "res://talking_head/Toriel/torie;_heads_clean_sweet_mommy_like.png"},
			]
		_:
			dialogue_queue = [
				{"text": "Ah Noelle,you're back again! Always a pleasure to see you.", "image": "res://talking_head/Toriel/torie;_heads_clean_happy.png"},
				{"text": "Take care of yourself, Noelle.", "image": "res://talking_head/Toriel/torie;_heads_clean_sweet_mommy_like.png"},
				{"text": "Thank you!", "image": "res://talking_head/noellee/noelle_heads_clean_nopink_sigel_happy.png"},
			]

	advance_dialogue()

func advance_dialogue():
	if dialogue_queue.size() > 0:
		current_dialogue = dialogue_queue.pop_front()
		show_dialogue_line(current_dialogue["text"], current_dialogue["image"])
	else:
		close_dialog()

func show_dialogue_line(text: String, image_path: String):
	if dialog_text:
		dialog_text.text = ""
		
	if talking_head:
		var texture = load(image_path)
		if texture:
			talking_head.texture = texture
			talking_head.show()
		else:
			talking_head.hide()
	if dialog_box:
		dialog_box.show()

	full_text = "* " + text
	char_index = 0
	typing = true
	typing_timer = 0.0

	if player:
		if player.has_method("set_can_move"):
			player.set_can_move(false)
		elif "can_move" in player:
			player.can_move = false

func close_dialog():
	if dialog_box:
		dialog_box.hide()
	if talking_head:
		talking_head.hide()
	if player:
		if player.has_method("set_can_move"):
			player.set_can_move(true)
		elif "can_move" in player:
			player.can_move = true

	dialogue_queue = []
	visit_count += 1  # ✅ increase visit count for next dialogue

func reset_dialogue():
	visit_count = 0
	dialogue_queue.clear()
	current_dialogue.clear()
	if dialog_box:
		dialog_box.hide()
	if talking_head:
		talking_head.hide()
	if dialog_text:
		dialog_text.text = ""
	print("DEBUG: Dialogue reset, visit count is now 0.")
