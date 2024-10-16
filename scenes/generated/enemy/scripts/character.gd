extends CharacterBody2D

@onready var nav_agent = $NavigationAgent2D
@export var speed = 50
@onready var player: CharacterBody2D

func _enter_tree() -> void:
	player = get_node("../../Player")

func _physics_process(delta: float) -> void:
	nav_agent.target_position = player.global_position
	if nav_agent.distance_to_target() > 50:
		$AnimatedSprite2D.play("moving")
		var next_position = nav_agent.get_next_path_position()
		var direction = (next_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		$AnimatedSprite2D.play("standing")
		velocity = Vector2.ZERO
