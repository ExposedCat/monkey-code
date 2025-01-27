extends StaticBody2D

var hp: int = 3

func _ready() -> void:
	add_to_group("hittable")

func hit():
	hp -= 1
	if hp == 0:
		queue_free()
	$Sprite2D.region_rect = Rect2((3 - hp) * 30, 0, 30, 32)
