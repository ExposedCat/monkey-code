extends CharacterBody2D

@export var speed: float = 250.0
@export var action = 'moving';
@export var last_direction = 'down';

func _physics_process(delta):
	velocity = Vector2()
	
	if Input.is_action_pressed("Down"):
		last_direction = "down";
		velocity.y = 1
	if Input.is_action_pressed("Up"):
		last_direction = "up";
		velocity.y = -1
	if Input.is_action_pressed("Right"):
		last_direction = "right";
		velocity.x = 1
	if Input.is_action_pressed("Left"):
		last_direction = "left";
		velocity.x = -1
		
	action = "standing" if velocity == Vector2.ZERO else "moving";
		
	$AnimatedSprite2D.play("%s-%s" % [action, last_direction]);

	if velocity != Vector2.ZERO:
		velocity = velocity.normalized()

	velocity *= speed
	move_and_slide()
