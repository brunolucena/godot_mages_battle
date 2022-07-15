extends KinematicBody2D

var speed := 200
var jump_speed := -700
var double_jump_speed := -500
var gravity := 2000

var velocity = Vector2.ZERO
var can_double_jump := true
var is_jumping = false

const DustJump := preload("res://Player/DustJump/DustJump.tscn")

onready var dustJump := DustJump.instance()

func _ready() -> void:
	$AnimationPlayer.play("idle")

func _physics_process(delta: float) -> void:
	get_horizontal_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	$DustRunRight.visible = false
	$DustRunLeft.visible = false
	
	if is_on_floor():
		if velocity.x != 0:
			$AnimationPlayer.play("run")

			if velocity.x > 0:
				$DustRunRight.visible = true
			else:
				$DustRunLeft.visible = true
		else:
			$AnimationPlayer.play("idle")

		if is_jumping:
			is_jumping = false
			play_dust_jump_animation()
				
	get_vertical_input()
	
func get_horizontal_input():
	velocity.x = 0

	if Input.is_action_pressed("right"):
		velocity.x += speed
		$Sprite.scale.x = 1
	if Input.is_action_pressed("left"):
		velocity.x -= speed
		$Sprite.scale.x = -1

func get_vertical_input():
	if Input.is_action_just_pressed("jump"):		
		if is_on_floor():
			can_double_jump = true
			$AnimationPlayer.play("Jump")
			velocity.y = jump_speed
			is_jumping = true
			play_dust_jump_animation()
		elif can_double_jump:
			can_double_jump = false
			$AnimationPlayer.play("Jump")
			velocity.y = double_jump_speed

func play_dust_jump_animation():
	get_viewport().add_child(dustJump)
	dustJump.start(position, self)
