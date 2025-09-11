extends Area2D

@onready var dialog_box = $"../../CanvasLayer/DialogueBox"
@onready var dialog_text = dialog_box.get_node("Panel/NinePatchRect/MarginContainer/HBoxContainer/Label")
@onready var talking_head = dialog_box.get_node("Panel/NinePatchRect/MarginContainer/HBoxContainer/TalkingHead")
@onready var player = get_node("../../Player")

var player_in_range := false
var current_line: int = 0
var dialogue_lines = [
	{"text": "You examine the mysterious painting...", "image": ""},
	{"text": "The brushstrokes are quite unusual", "image": "res://talking_head/noellee/noelle_heads_clean_nopink_sigel_curious.png"},
	{"text": "It seems to depict a forgotten memory", "image": "res://talking_head/noellee/noelle_heads_clean_nopink_sigel_smile-happy.png"},
	{"text": "There's something familiar about it...", "image": "res://talking_head/noellee/noelle_heads_clean_nopink_sigel_thinking.png"},
	{"text": "Or... ", "image": "res://talking_head/noellee/noelle_heads_clean_nopink_sigel_thinking.png"},
	{"text": "Its not that deep", "image": "res://talking_head/noellee/noelle_heads_clean_nopink_sigel_smile-happy.png"}
]

# Typing effect variables
var current_text: String = ""
var typing_index: int = 0
var typing_speed: float = 0.05
var typing_timer: float = 0.0
var is_typing: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		print("Player near painting")

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		print("Player left painting")

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		if dialog_box.visible:
			if is_typing:
				# Skip typing effect - show full text immediately
				skip_typing()
			else:
				advance_dialogue()
		else:
			if DialogueManager.can_start_dialogue():
				start_dialogue()
			else:
				print("Someone else is talking")
	
	# Typing effect
	if is_typing:
		typing_timer += delta
		if typing_timer >= typing_speed:
			typing_timer = 0
			if typing_index < current_text.length():
				dialog_text.text += current_text[typing_index]
				typing_index += 1
			else:
				is_typing = false
				print("Typing complete")

func start_dialogue():
	DialogueManager.start_dialogue()
	current_line = 0
	dialog_box.show()
	player.can_move = false
	player.velocity = Vector2.ZERO
	show_line(current_line)

func advance_dialogue():
	current_line += 1
	if current_line < dialogue_lines.size():
		show_line(current_line)
	else:
		end_dialogue()

func show_line(line_index):
	var dialogue = dialogue_lines[line_index]
	
	# Handle talking head image
	if dialogue["image"].is_empty():
		talking_head.hide()
	else:
		var texture = load(dialogue["image"])
		if texture:
			talking_head.texture = texture
			talking_head.show()
		else:
			print("Error: Image not found - ", dialogue["image"])
			talking_head.hide()
	
	# Start typing effect
	current_text = "* " + dialogue["text"] 
	dialog_text.text = ""
	typing_index = 0
	is_typing = true
	typing_timer = 0.0

func skip_typing():
	# Show full text immediately
	dialog_text.text = current_text
	is_typing = false

func end_dialogue():
	DialogueManager.end_dialogue()
	dialog_box.hide()
	talking_head.hide()
	player.can_move = true
