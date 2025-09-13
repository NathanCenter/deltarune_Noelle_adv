extends CharacterBody2D

@onready var anim_sprite: = $PlayerAnimation
@export var speed := 100.0
var can_move = true
# suppost to stop the animtion.
func freeze():
	can_move = false
	velocity = Vector2.ZERO
	if has_node("PlayerAnimation"):
		get_node("PlayerAnimation").stop()
	elif has_node("PlayerAnimation"):
		get_node("PlayerAnimation").stop()

func unfreeze():
	can_move = true
	if has_node("PlayerAnimation"):
		get_node("PlayerAnimation").play("idle")
	elif has_node("PlayerAnimation"):
		get_node("PlayerAnimation").play("idle")
func _physics_process(delta):
	var dir = Vector2.ZERO
	if can_move:
		if Input.is_action_pressed("move_right"):
			anim_sprite.play("move_right")
			dir.x += 1
		if Input.is_action_pressed("move_left"):
			anim_sprite.play("move_left")
			dir.x -= 1
		if Input.is_action_pressed("move_down"):
			anim_sprite.play("move_down")
			dir.y += 1
		if Input.is_action_pressed("move_up"):
			anim_sprite.play("move_up")
			dir.y -= 1
		if Input.is_action_just_pressed("interact"):
			print("interact with an object")
		if dir != Vector2.ZERO:
			dir = dir.normalized()
			velocity = dir * speed
			#anim_sprite.play("idle")
		else:
			velocity = Vector2.ZERO
			anim_sprite.stop()
	else:
		velocity = Vector2.ZERO

	move_and_slide()
