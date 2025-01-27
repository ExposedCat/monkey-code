extends CharacterBody2D

@onready var navigation = $NavigationAgent2D
@onready var player: CharacterBody2D

@export var speed = 50
@export var following = false


var set_follow__js = JavaScriptBridge.create_callback(set_follow)
func set_follow(args):
	if get_instance_id() == args[0]:
		following = args[1]

func _enter_tree() -> void:
	player = get_node("../../Player")
	Bridge.register_event("enemy:follow", set_follow__js)
	Bridge.dispatch_event("enemy:spawned", {
		"id": get_instance_id()
	})

func _physics_process(_delta: float) -> void:
	var stand = func():
		$AnimatedSprite2D.play("standing")
		velocity = Vector2.ZERO

	if following:
		navigation.target_position = player.global_position
		if navigation.distance_to_target() > 50:
			$AnimatedSprite2D.play("moving")
			var next_position = navigation.get_next_path_position()
			var direction = (next_position - global_position).normalized()
			velocity = direction * speed
			move_and_slide()
		else:
			stand.call()
	else:
		stand.call()
