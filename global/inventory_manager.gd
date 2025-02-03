extends Node

class Inventory:
	signal inventory_change(inventory)

	var inventory = []

	func add_item(type: String, amount: int) -> bool:
		var added = false
		for slot in inventory:
			if slot["amount"] < 10 and slot["type"] == type:
				slot["amount"] += 1
				added = true
				break
				
		if not added:
			if inventory.size() == 10:
				return false
			inventory.append({
				"type": type,
				"amount": amount
			})
		
		inventory_change.emit(inventory)
		return true

	func remove_item(type: String, amount: int) -> bool:
		if not has_item(type, amount):
			return false
			
		for slot in inventory:
			if slot["type"] == type:
				var used = min(slot["amount"], amount)
				amount -= used
				slot["amount"] -= used
				if slot["amount"] == 0:
					inventory.erase(slot)
				if amount == 0:
					break
					
		inventory_change.emit(inventory)
		return true

	func get_inventory():
		return inventory
		
	func has_item(type: String, amount: int) -> bool:
		for slot in inventory:
			if slot["type"] == type:
				var used = min(slot["amount"], amount)
				amount -= used
				if amount == 0:
					return true
		return false
		

var player = Inventory.new()
