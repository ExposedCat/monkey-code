extends CanvasLayer

@onready var main_ui = $"../../UI"
@onready var build_button = $"../../UI/Build"
@onready var preview = $"../Build Preview"
@onready var entities = $"../../Entities"

var stone_scene = preload("res://scenes/items/stone/scene.tscn")
var furnance_scene = preload("res://scenes/items/furnance/scene.tscn")
var buildable_data = {
	"stone": {
		"scene": stone_scene,
		"requirement": 3
	},
	"furnance": {
		"scene": furnance_scene,
		"requirement": 10
	}
}

var buildable = null

func set_preview_open(state: bool, new_buildable = null) -> void:
	main_ui.set_raw_open("build", state)
	build_button.text = "Cancel" if state else "Build"
	preview.visible = state
	buildable = new_buildable
	
func set_open(state: bool):
	visible = state
	if not visible:
		set_preview_open(false)

func on_select_stone():
	on_select("stone")
	
func on_select_furnance():
	on_select("furnance")
	
func on_select(item: StringName):
	if not InventoryManager.player.has_item("stone", buildable_data[item]["requirement"]):
		return
	main_ui.set_open("build", false)
	set_preview_open(true, item)
	
func on_build(position: Vector2):
	if buildable != null and InventoryManager.player.remove_item("stone", buildable_data[buildable]["requirement"]):
		var scene = buildable_data[buildable]["scene"].instantiate()
		scene.position = position
		entities.add_child.call_deferred(scene)
		set_preview_open(false)
