extends Area2D

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	var instance_id = get_parent().get_instance_id()
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed == false:
			Bridge.dispatch_event("monkey:clicked", {
				"id": instance_id
			})
