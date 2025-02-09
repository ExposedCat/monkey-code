extends Node2D

var SPEED = 0.25
var OFFSET = 200
var MAX_SHIFT = 20
var CORNER_FIX_SIZE = 100
var CORNER_FIX_OFFSET = 10

var horizontal: Array[Sprite2D] = []
var vertical: Array[Sprite2D] = []
var max_offset = 0

var images = build_images([
	load("res://assets/map/cloud-1.png"),
	load("res://assets/map/cloud-2.png"),
	load("res://assets/map/cloud-3.png"),
	load("res://assets/map/cloud-4.png"),
	load("res://assets/map/cloud-5.png"),
	load("res://assets/map/cloud-6.png"),
])

func build_images(loaded_images: Array) -> Array:
	var result = []
	for image in loaded_images:
		var pack = []
		for i in range(3):
			var target = image
			if i != 0:
				target = target.duplicate()
				target.rotate_90(CLOCKWISE if i == 1 else COUNTERCLOCKWISE)
			pack.append(ImageTexture.create_from_image(target))
		result.append(pack)
		var offset = pack[0].get_height() / 2
		if offset > max_offset:
			max_offset = offset
	return result


func create_cloud(offset: float, orientation: String) -> Array[float]:
	var textures: Array = images.pick_random()
	var width = textures[0].get_width()
	var height = textures[0].get_height()
	var shift = -randf_range(0, MAX_SHIFT)
	for end in [true, false]:
		var cloud = Sprite2D.new()
		cloud.z_index = 1
		cloud.centered = false
		cloud.y_sort_enabled = false
		cloud.texture = textures[0 if orientation == "horizontal" else 2 if end else 1]
		
		if orientation == "horizontal":
			cloud.position = Vector2(offset + shift, Constants.height if end else 0)
			if end:
				cloud.offset = Vector2(0, -max_offset)
			horizontal.append(cloud)
		else:
			cloud.position = Vector2(Constants.width if end else 0, offset + shift)
			if end:
				cloud.offset = Vector2(-max_offset, 0)
			vertical.append(cloud)
		
		if end or orientation != "horizontal":
			cloud.flip_v = true
			cloud.flip_h = true
		
		add_child(cloud)
		if end or orientation != "horizontal":
			move_child(cloud, 0)
			
	return [width, shift]

func _ready() -> void:
	var width = [-OFFSET / 2.0, Constants.width, "horizontal"]
	var height = [-OFFSET / 2.0, Constants.height, "vertical"]
	while true:
		var filled = 0
		for dimension in [width, height]:
			if dimension[0] < dimension[1] + OFFSET:
				var size = create_cloud(dimension[0], dimension[2])
				dimension[0] += size[0] + size[1]
			else:
				filled += 1
		if filled == 2:
			break

func _process(_delta: float) -> void:
	for cloud in horizontal:
		cloud.position.x += SPEED
		if cloud.position.x > Constants.width:
			cloud.position.x = -OFFSET / 2.0
	for cloud in vertical:
		cloud.position.y += SPEED
		if cloud.position.y > Constants.height:
			cloud.position.y = -OFFSET / 2.0
		
