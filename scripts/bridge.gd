extends Node

func _init():
  JavaScriptBridge.eval("""
    var godotBridge = {
      _godot_callbacks: {},
      _godot_listen: (name, callback) => {
        window.godotBridge._godot_callbacks[name] ??= []
        window.godotBridge._godot_callbacks[name].push(callback)
      },
      _events: new EventTarget(),
      _godot_dispatch: (name, data) => godotBridge._events.dispatchEvent(new CustomEvent(name, { detail: data })),
      on: (name, callback) => godotBridge._events.addEventListener(name, callback),
      off: (name, callback) => godotBridge._events.removeEventListener(name, callback),
      dispatch: (name, args = []) => window.godotBridge._callbacks[name]?.forEach(callback => callback(...args)),
    };
	""", true)

func register_event(event: String, callback: JavaScriptObject):
  var bridge = JavaScriptBridge.get_interface("godotBridge")
  bridge._godot_listen(event, callback)

func dispatch_event(event: String, data):
  var bridge = JavaScriptBridge.get_interface("godotBridge")
  bridge._godot_dispatch(event, JSON.stringify(data))