extends Timer

@export var enemy_scene = preload("res://scenes/generated/enemy/scene.tscn")

@onready var map_bounds = $"../../Map/StaticBody2D/CollisionPolygon2D"

@export var max_enemies: int = 30

var current_enemies: int = 0

func _ready() -> void:
	self.timeout.connect(spawn_enemy)

func spawn_enemy():
	if current_enemies >= max_enemies:
		return
		
	var enemy = enemy_scene.instantiate()
	enemy.position = get_random_position()

	get_parent().add_child(enemy)
	
	current_enemies += 1
	enemy.connect("tree_exiting", self._on_enemy_removed)

func get_random_position() -> Vector2:
	var rect_shape: PackedVector2Array = map_bounds.polygon
	var top_left = rect_shape[5]
	var bottom_right = rect_shape[3]
	
	var size = 14
	
	var rand_x = randf_range(top_left.x + size, bottom_right.x - size)
	var rand_y = randf_range(top_left.y + size, bottom_right.y - size)

	return Vector2(rand_x, rand_y)

func _on_enemy_removed():
	current_enemies = clamp(current_enemies - 1, 0, max_enemies)
