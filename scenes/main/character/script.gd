extends CharacterBody2D

@onready var camera = $Camera2D
@onready var sprite = $AnimatedSprite2D

@export var speed: float = 250.0
@export var hit_cooldown: float = 500.0
@export var hit_range: float = 50.0

var action = "standing";
var last_direction = "down";
var last_hit = 0;

var direction_vectors = {
	"up": Vector2(0, -1),
	"down": Vector2(0, 1),
	"left": Vector2(-1, 0),
	"right": Vector2(1, 0)
}

func _ready():
	position.x = float(Constants.width) / 2 + 5
	position.y = float(Constants.height) / 2 + 20
	camera.limit_right = Constants.width
	camera.limit_bottom = Constants.height

func _physics_process(_delta):
	if action == "hit":
		return
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
	
	if Input.is_action_just_pressed("Hit") and Time.get_ticks_msec() - last_hit >= hit_cooldown:
		last_hit = Time.get_ticks_msec()
		velocity = Vector2.ZERO
		action = "hit"
		var nearest = get_nearest_hittable()
		if nearest[0] != null and nearest[1] <= hit_range:
			nearest[0].interact(InventoryManager.player)
		
	sprite.play("%s-%s" % [action, last_direction]);

	if velocity != Vector2.ZERO:
		velocity = velocity.normalized()

	velocity *= speed
	move_and_slide()

func get_nearest_hittable():
	var nearest_hittable = null
	var nearest_distance = INF
	var dir_vector = direction_vectors.get(last_direction, Vector2.ZERO)

	for hittable: Node2D in get_tree().get_nodes_in_group("hittable"):
		var offset = (hittable.global_position - global_position).normalized()
		var dot = dir_vector.dot(offset)

		var distance = global_position.distance_to(hittable.global_position)
		if distance < nearest_distance and dot > 0:
			nearest_distance = distance
			nearest_hittable = hittable

	return [nearest_hittable, nearest_distance]
	

func _on_animation_finished() -> void:
	if sprite.animation.begins_with("hit"):
		action = "standing"
