extends CanvasLayer

func _on_open_editor_pressed() -> void:
	JavaScriptBridge.eval("window.dispatchEvent(new CustomEvent('open-editor'))")
