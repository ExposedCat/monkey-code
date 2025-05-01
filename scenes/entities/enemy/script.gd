extends CharacterBody2D

@export var knockback_force = 850
@export var speed = 50
@export var health = 50
@export var hit_cooldown = 1000
@export var following = true

@onready var navigation_node = $NavigationAgent2D
@onready var sprite_node = $AnimatedSprite2D
@onready var jump_sound_node = $"../Jump"
@onready var effects_node = $"../Effects"

@onready var player_node: CharacterBody2D
@onready var follow_target: StaticBody2D = null

enum State {
	ALIVE,
	DEAD,
	STUNNED
}

enum Action {
	STANDING,
	MOVING,
	JUMPING,
	KNOCKBACK
}

var state = State.ALIVE
var action = Action.STANDING
var inventory = InventoryManager.Inventory.new()

var last_hit_time = 0;

func _enter_tree() -> void:
	player_node = get_node("../../Player")
	Bridge.dispatch_event("enemy:spawned", {
		"id": get_instance_id()
	})

func play_action():
	var action_name: StringName
	match action:
		Action.STANDING: action_name = "standing"
		Action.MOVING: action_name = "moving"
		Action.JUMPING: action_name = "jumping"
		Action.KNOCKBACK: action_name = "knockback"
	sprite_node.play("enemy-%s" % [action_name])

func _ready() -> void:
	$AnimatedSprite2D.material = $AnimatedSprite2D.material.duplicate()
	play_action()

func set_action(new_action: Action):
	if action != new_action:
		Bridge.dispatch_event("enemy:action", {
			"id": get_instance_id(),
			"action": new_action
		})
		action = new_action
		play_action()
		match new_action:
			Action.MOVING:
				jump_sound_node.play()
			Action.STANDING:
				jump_sound_node.stop()

func stand():
	set_action(Action.STANDING)
	velocity = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	if state != State.ALIVE:
		return

	if follow_target and not is_instance_valid(follow_target):
		follow_target = null

	if following or follow_target:
		navigation_node.target_position = follow_target.global_position if follow_target else player_node.global_position
		if navigation_node.distance_to_target() > 20:
			set_action(Action.MOVING)
			var next_position = navigation_node.get_next_path_position()
			var direction = (next_position - global_position).normalized()
			velocity = direction * speed
			move_and_slide()
		else:
			if follow_target and Time.get_ticks_msec() - last_hit_time >= hit_cooldown:
				last_hit_time = Time.get_ticks_msec()
				velocity = Vector2.ZERO
				follow_target.interact(inventory)
			stand()
	else:
		stand()

func take_hit(damage: int, attacker: CharacterBody2D):
	if health > 0:
		Bridge.dispatch_event("enemy:damaged", {
			"id": get_instance_id()
		})
		health -= damage
		effects_node.play("hit")
		state = State.STUNNED
		await get_tree().create_timer(0.05).timeout
		var knockback_direction = (global_position - attacker.global_position).normalized()
		velocity = knockback_direction * knockback_force
		move_and_slide()
		if health <= 0:
			state = State.DEAD
			sprite_node.play("enemy-dying")

func _on_effect_finished(effect_name: StringName) -> void:
	if effect_name == "hit" and state == State.STUNNED:
		state = State.ALIVE

func _on_animation_finished() -> void:
	if $"AnimatedSprite2D".animation == "enemy-dying":
		Bridge.dispatch_event("enemy:destroyed", {
			"id": get_instance_id()
		})
		queue_free()
