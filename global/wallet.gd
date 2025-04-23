extends Node

class WalletInstance:
	signal value_change(change: float, new_value: float)
	
	var _value: float = 0
	
	func _init(initial_value: float = 0) -> void:
		self.change(initial_value)
		
	func change(value: float) -> void:
		_value += value
		value_change.emit(value, _value)

	func get_value() -> float:
		return _value

var player_hp = WalletInstance.new()
var player_money = WalletInstance.new()
