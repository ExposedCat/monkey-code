extends CanvasLayer

var stone_scene = preload("res://scenes/items/stone/scene.tscn")
var building = false

func toggle_open() -> bool:
	if building:
		cancel()
		return false
	visible = not visible
	return true

func on_select_stone():
	toggle_open()
	$"../../UI/Build".text = "Cancel"
	$"../Preview".visible = true
	building = true
	$"../../UI".toggle_pause()
	
func cancel() -> void:
	$"../../UI/Build".text = "Build"
	$"../Preview".visible = false
	building = false
	
func on_build(position: Vector2):
	var stone = stone_scene.instantiate()
	stone.position = position
	$"../../Entities".add_child.call_deferred(stone)
	cancel()
