extends Sprite2D

var collides = false

var allowed_texture = load("res://assets/ui/preview/builder.png")
var not_allowed_texture = load("res://assets/ui/preview/builder-overlaps.png")

func handle_collision(has_collision: bool):
	if collides != has_collision:
		collides = has_collision
		texture = not_allowed_texture if collides else allowed_texture

func _process(_delta: float) -> void:
	if visible:
		position = get_global_mouse_position()
		handle_collision($Area2D.has_overlapping_areas() or $Area2D.has_overlapping_bodies())


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and not collides:
		$"../Menu".on_build(position)
