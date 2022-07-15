extends Node
class_name DustJump
# Handles adding DustJumpAnimatedSprite effects to the Player.

# dust_cooldown  will prevent multiple instances from stacking on each other.

# To trigger the effect, "start" is called passing the position on the map and the
# node that called it (usually the Player). A new DustJumpAnimatedSprite is then added
# to the viewport, being freed after playing the animation.

export var dust_cooldown = 0.1
var active_dusts = {}

onready var dust_jump = $DustJumpAnimatedSprite

# Play the DustJumpAnimatedSprite if it's not on cooldown and bind it's finish function
func start(_position: Vector2, node: Node) -> void:
	if is_on_cooldown(node):
		return
	
	var new_dust = $DustJumpAnimatedSprite.duplicate()
	apply_cooldown(_position, new_dust, node)

	new_dust.position = _position
	get_viewport().add_child(new_dust)
	
	new_dust.visible = true
	new_dust.playing = true
	
	bind_finish(new_dust)

# Free the DustJumpAnimatedSprite when it's animation finishes
func bind_finish(dust: DustJumpAnimatedSprite):
	yield(dust, "animation_finished")
	dust.queue_free()

func is_on_cooldown(node: Node) -> bool:
	return active_dusts.get(node.get_instance_id(), false)

# 
func apply_cooldown(_position: Vector2, dust: DustJumpAnimatedSprite, node: Node):
	active_dusts[node.get_instance_id()] = true
	yield(get_tree().create_timer(dust_cooldown), "timeout")
	active_dusts.erase(node.get_instance_id())
