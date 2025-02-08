extends CanvasLayer

var editor_opened = false


var toggle_pause__js = JavaScriptBridge.create_callback(toggle_pause)
func toggle_pause(args = null):
	var tree = get_tree()
	tree.paused = not tree.paused
	if not tree.paused:
		editor_opened = false
	return tree.paused


func _enter_tree() -> void:
	Bridge.register_event("system:pause", toggle_pause__js)


func _on_open_editor_pressed() -> void:
	toggle_pause()
	var dispatcher = "window.dispatchEvent(new CustomEvent('%s-editor'))" % ["open" if not editor_opened else "close"]
	editor_opened = not editor_opened
	JavaScriptBridge.eval(dispatcher)


func _on_pause_pressed() -> void:
	var paused = toggle_pause()
	$"Pause Tint".visible = paused
	$Pause.text = "Continue" if paused else "Pause"
