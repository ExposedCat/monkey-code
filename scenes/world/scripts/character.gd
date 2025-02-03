extends CharacterBody2D

@export var speed: float = 250.0
@export var hit_range: float = 50.0
@export var action = 'moving';
@export var last_direction = 'down';

var direction_vectors = {
	"up": Vector2(0, -1),
	"down": Vector2(0, 1),
	"left": Vector2(-1, 0),
	"right": Vector2(1, 0)
}

func _ready():
	position.x = Constants.width / 2 + 5
	position.y = Constants.height / 2 + 20

func _physics_process(_delta):
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
		
	if Input.is_action_just_pressed("Hit"):
		var nearest = get_nearest_hittable()
		if nearest[0] != null and nearest[1] <= hit_range:
			nearest[0].hit(InventoryManager.player)
		
	action = "standing" if velocity == Vector2.ZERO else "moving";
	$AnimatedSprite2D.play("%s-%s" % [action, last_direction]);

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
	
