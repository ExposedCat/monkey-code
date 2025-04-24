extends Timer

@export var monkey_scene = preload("res://scenes/entities/monkey/scene.tscn")

@export var max_enemies: int = 300

var current_enemies: int = 0

func _ready() -> void:
	self.timeout.connect(spawn_monkey)

func spawn_monkey():
	if current_enemies >= max_enemies:
		return

	var monkey = monkey_scene.instantiate()
	monkey.position = get_random_position()

	get_parent().add_child.call_deferred(monkey)

	current_enemies += 1
	monkey.connect("tree_exiting", self._on_monkey_removed)

func get_random_position() -> Vector2:
	var size = 14

	var rand_x = randf_range(size, Constants.width - size)
	var rand_y = randf_range(size, Constants.height - size)

	return Vector2(rand_x, rand_y)

func _on_monkey_removed():
	current_enemies = clamp(current_enemies - 1, 0, max_enemies)
