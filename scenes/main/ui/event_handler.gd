extends CanvasLayer

var editor_opened = false

func toggle_pause():
	var tree = get_tree()
	tree.paused = not tree.paused
	return tree.paused

func _on_open_editor_pressed() -> void:
	toggle_pause()
	var dispatcher = "window.dispatchEvent(new CustomEvent('%s-editor'))" % ["open" if not editor_opened else "close"]
	$"Open Editor".text = "Open Editor" if editor_opened else "Close Editor"
	editor_opened = not editor_opened
	JavaScriptBridge.eval(dispatcher)

func _on_pause_pressed() -> void:
	var paused = toggle_pause()
	$"Pause Tint".visible = paused
	$Pause.text = "Continue" if paused else "Pause"
