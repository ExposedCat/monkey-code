extends CanvasLayer

var buttons = []
var labels = []
var opened = {
	"pause": false,
	"build": false,
	"editor": false,
}

func _ready() -> void:
	buttons = [$Build, $"Open Editor", $Pause]
	labels = buttons.map(func (button): return button.text)

### Helpers
func set_pause(state: bool):
	var tree = get_tree()
	tree.paused = state
	$"Pause Tint".visible = state
	
func set_raw_open(target: StringName, state: bool):
	opened[target] = state

func set_open(target: StringName, state: bool) -> void:
	opened["editor"] = false
	opened["build"] = false
	set_pause(state)
	opened[target] = state

	var index = 0 if target == "build" else 1 if target == "editor" else 2
	var button = buttons[index]
	if state:
		for other_button in buttons:
			move_child(button, 1)
		move_child(button, 4)
	
	button.text = "Continue" if state else labels[index]
	
	match target:
		"build":
			$"../Builder/Build Menu".set_open(state)
		"editor":
			var dispatcher = "window.dispatchEvent(new CustomEvent('%s-editor'))" % ["open" if not state else "close"]
			JavaScriptBridge.eval(dispatcher)

### Client Events
#var toggle_pause__js = JavaScriptBridge.create_callback(toggle_pause)
#func toggle_pause(_args = null):
	#var tree = get_tree()
	#tree.paused = not tree.paused
	#if not tree.paused:
		#editor_opened = false
	#$"Pause Tint".visible = tree.paused
	#return tree.paused

#func _enter_tree() -> void:
	#Bridge.register_event("system:pause", toggle_pause__js)

### Button handlers
func _on_pause_pressed() -> void:
	set_open("pause", not opened["pause"])

func _on_editor_pressed() -> void:
	set_open("editor", not opened["editor"])

func _on_build_pressed() -> void:
	set_open("build", not opened["build"])
