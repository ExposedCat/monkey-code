extends Timer

@export var enemy_scene = preload("res://scenes/generated/enemy/scene.tscn")

@export var max_enemies: int = 300

var current_enemies: int = 0

func _ready() -> void:
	self.timeout.connect(spawn_enemy)

func spawn_enemy():
	if current_enemies >= max_enemies:
		return
		
	var enemy = enemy_scene.instantiate()
	enemy.position = get_random_position()

	get_parent().add_child.call_deferred(enemy)
	
	current_enemies += 1
	enemy.connect("tree_exiting", self._on_enemy_removed)

func get_random_position() -> Vector2:
	var size = 14
	
	var rand_x = randf_range(size, Constants.width - size)
	var rand_y = randf_range(size, Constants.height - size)

	return Vector2(rand_x, rand_y)

func _on_enemy_removed():
	current_enemies = clamp(current_enemies - 1, 0, max_enemies)
