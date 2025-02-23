extends CanvasLayer

var editor_opened = false


var buttons = []
var labels = []

func _ready() -> void:
	buttons = [$Build, $"Open Editor", $Pause]
	labels = buttons.map(func (button): return button.text)

var toggle_pause__js = JavaScriptBridge.create_callback(toggle_pause)
func toggle_pause(_args = null):
	var tree = get_tree()
	tree.paused = not tree.paused
	if not tree.paused:
		editor_opened = false
	$"Pause Tint".visible = tree.paused
	return tree.paused

func _enter_tree() -> void:
	Bridge.register_event("system:pause", toggle_pause__js)


func _on_open_editor_pressed() -> void:
	toggle_pause()
	var dispatcher = "window.dispatchEvent(new CustomEvent('%s-editor'))" % ["open" if not editor_opened else "close"]
	editor_opened = not editor_opened
	JavaScriptBridge.eval(dispatcher)


func _on_pause_pressed() -> void:
	handle_pause("pause")

func _on_editor_pressed() -> void:
	handle_pause("editor")

func _on_build_pressed() -> void:
	var should_pause = $"../Builder/Menu".toggle_open()
	if should_pause:
		handle_pause("build")

func handle_pause(from: StringName) -> void:	
	for button in buttons:
		move_child(button, 1)
		
	var index = 0 if from == "build" else 1 if from == "editor" else 2
	var target = buttons[index]
	move_child(target, 4)
	
	var paused = toggle_pause()
	
	target.text = "Continue" if paused else labels[index]
