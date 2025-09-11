# DialogueManager.gd (simplified)
extends Node

var is_dialogue_active: bool = false

func can_start_dialogue() -> bool:
	return not is_dialogue_active

func start_dialogue():
	is_dialogue_active = true
	print("Dialogue started")

func end_dialogue():
	is_dialogue_active = false
	print("Dialogue ended")
